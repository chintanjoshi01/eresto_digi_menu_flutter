allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://download.shorebird.dev/download.flutter.io") }
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// --- FIX START ---
subprojects {
    // 1. Fix Namespace for Isar/Plugins
    plugins.withId("com.android.library") {
        val android = extensions.getByName("android")
        try {
            val getNamespace = android.javaClass.getMethod("getNamespace")
            if (getNamespace.invoke(android) == null) {
                val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                setNamespace.invoke(android, project.group.toString())
                println("Auto-assigned namespace '${project.group}' to ${project.name}")
            }
        } catch (e: Exception) {}
    }

    // 2. Fix "Different Roots" Error (Drive C vs D)
    // We disable UnitTests for all plugins. This prevents Gradle from trying
    // to calculate the path between C: and D:, which causes the crash.
    // 3. Force Compile SDK for all subprojects to fix LStar resource error
    afterEvaluate {
        val android = extensions.findByName("android")
        if (android != null) {
            try {
                // Try different ways to set compileSdk
                val javaClass = android.javaClass
                val methods = javaClass.methods
                
                val compileSdkSetter = methods.find { it.name == "setCompileSdk" && it.parameterTypes.size == 1 && it.parameterTypes[0] == Int::class.javaPrimitiveType }
                val compileSdkVersionSetter = methods.find { it.name == "setCompileSdkVersion" && it.parameterTypes.size == 1 && it.parameterTypes[0] == Int::class.javaPrimitiveType }
                
                if (compileSdkSetter != null) {
                    compileSdkSetter.invoke(android, 35)
                    println("Forced compileSdk 35 for ${project.name}")
                } else if (compileSdkVersionSetter != null) {
                    compileSdkVersionSetter.invoke(android, 35)
                    println("Forced compileSdkVersion 35 for ${project.name}")
                } else {
                    println("Could not find compileSdk setter for ${project.name}")
                }
            } catch (e: Exception) {
                println("Error forcing compileSdk for ${project.name}: ${e.message}")
            }
        }
    }
}
// --- FIX END ---

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
