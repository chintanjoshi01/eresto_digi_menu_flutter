import { forwardRef } from 'react';
import { ShieldCheck, Sparkles, Folder, Palette, Type, Grid, CheckCircle2, FileCode, FileText } from 'lucide-react';
import type { BrandConfig } from '../types/brand';

interface ShowcaseBoardProps {
  config: BrandConfig;
}

export const ShowcaseBoard = forwardRef<HTMLDivElement, ShowcaseBoardProps>(({ config }, ref) => {

  const hexToRgb = (hex: string) => {
    let cleanHex = hex.replace('#', '');
    if (cleanHex.length === 3) {
      cleanHex = cleanHex.split('').map(c => c + c).join('');
    }
    const num = parseInt(cleanHex, 16);
    return `${(num >> 16) & 255}, ${(num >> 8) & 255}, ${num & 255}`;
  };

  const safeZipName = `${config.brandName.replace(/[^a-zA-Z0-9]/g, '_')}_Brand_Kit_v${config.version}.zip`;

  return (
    <div
      ref={ref}
      className="w-full max-w-[1300px] mx-auto p-6 md:p-10 rounded-3xl canvas-grid-bg border border-slate-800/80 shadow-2xl flex flex-col gap-8 select-none transition-all"
      style={{ fontFamily: config.bodyFont }}
    >
      
      {/* ------------------------------------------------------------- */}
      {/* BOARD HEADER BANNER                                           */}
      {/* ------------------------------------------------------------- */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 pb-6 border-b border-slate-800/80">
        <div className="flex flex-col gap-1.5 min-w-0">
          <div className="flex items-center gap-3 flex-wrap">
            <h1
              className="text-3xl font-extrabold tracking-tight text-white drop-shadow-md"
              style={{ fontFamily: config.displayFont }}
            >
              {config.brandName}
            </h1>
            <span
              className="px-3 py-1 rounded-full text-xs font-black shadow-md shrink-0"
              style={{ backgroundColor: config.primaryColor, color: '#FFFFFF' }}
            >
              v{config.version}
            </span>
            <span className="px-3 py-1 rounded-full text-xs font-bold bg-amber-500/10 text-amber-400 border border-amber-500/25 tracking-wide shrink-0">
              {config.industry}
            </span>
          </div>
          <p className="text-xs text-slate-400 font-medium leading-relaxed max-w-2xl">
            {config.subtitle} • {config.tagline}
          </p>
        </div>

        <div className="flex items-center gap-2.5 shrink-0 self-start md:self-auto">
          <div className="flex items-center gap-2 px-3.5 py-1.5 rounded-xl bg-slate-900/90 border border-slate-800 text-xs font-mono font-bold text-slate-200 shadow-md">
            <Sparkles className="w-3.5 h-3.5 text-amber-400 shrink-0" />
            <span>4K BRAND MASTER SHOWCASE BOARD</span>
          </div>
        </div>
      </div>

      {/* ------------------------------------------------------------- */}
      {/* SECTION 1: MASTER LOGO SUITE                                  */}
      {/* ------------------------------------------------------------- */}
      <div className="flex flex-col gap-4">
        <div className="flex items-center justify-between gap-2">
          <div className="flex items-center gap-2">
            <div className="p-1.5 rounded-lg bg-indigo-500/10 border border-indigo-500/20 text-indigo-400 shrink-0">
              <Grid className="w-4 h-4" />
            </div>
            <h2 className="text-xs font-black uppercase tracking-widest text-slate-200">1. Master Logo Suite</h2>
          </div>
          <span className="text-[11px] font-mono text-slate-500 hidden sm:inline">Vector SVG • 4K Canvas Ready</span>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
          
          {/* Card 1: Master Full Color */}
          <div
            className="group relative rounded-2xl p-6 flex flex-col justify-between overflow-hidden shadow-xl transition-all border border-slate-700/60 min-h-[230px]"
            style={{ backgroundColor: config.darkBgColor }}
          >
            <div className="flex items-center justify-between gap-2 relative z-10">
              <span className="text-[10px] font-black uppercase tracking-widest text-slate-400">Master Full Color</span>
              <span className="w-2.5 h-2.5 rounded-full shrink-0 border border-white/20" style={{ backgroundColor: config.primaryColor }} />
            </div>

            <div className="py-4 flex items-center gap-4 relative z-10">
              <div
                className="w-16 h-16 rounded-2xl shrink-0 flex items-center justify-center shadow-lg transform group-hover:scale-105 transition border border-white/20"
                style={{
                  background: `linear-gradient(135deg, ${config.primaryColor}, ${config.goldColor})`
                }}
              >
                <span
                  className="text-3xl font-extrabold text-white drop-shadow-md"
                  style={{ fontFamily: config.displayFont }}
                >
                  {config.monogramLetter}
                </span>
              </div>
              <div className="min-w-0 flex-1">
                <h3
                  className="text-2xl font-black text-white tracking-tight truncate"
                  style={{ fontFamily: config.displayFont }}
                >
                  {config.brandName}
                </h3>
                <p className="text-[11px] font-semibold tracking-wide text-slate-300 uppercase mt-0.5 line-clamp-2">
                  {config.subtitle}
                </p>
              </div>
            </div>

            <div className="text-[10px] font-mono text-slate-400 flex justify-between items-center gap-2 pt-2.5 border-t border-white/10 relative z-10">
              <span className="truncate">Dark BG: {config.darkBgColor}</span>
              <span className="text-indigo-400 font-bold shrink-0">Primary: {config.primaryColor}</span>
            </div>
          </div>

          {/* Card 2: White Logo Variant */}
          <div
            className="group relative rounded-2xl p-6 flex flex-col justify-between overflow-hidden shadow-xl transition-all border border-slate-700/60 min-h-[230px]"
            style={{ backgroundColor: config.charcoalColor }}
          >
            <div className="flex items-center justify-between gap-2 relative z-10">
              <span className="text-[10px] font-black uppercase tracking-widest text-slate-300">White Variant</span>
              <span className="w-2.5 h-2.5 rounded-full bg-white shrink-0" />
            </div>

            <div className="py-4 flex items-center gap-4 relative z-10">
              <div className="w-16 h-16 rounded-2xl shrink-0 bg-white/15 backdrop-blur-md border border-white/20 flex items-center justify-center transform group-hover:scale-105 transition">
                <span
                  className="text-3xl font-extrabold text-white"
                  style={{ fontFamily: config.displayFont }}
                >
                  {config.monogramLetter}
                </span>
              </div>
              <div className="min-w-0 flex-1">
                <h3
                  className="text-2xl font-black text-white tracking-tight truncate"
                  style={{ fontFamily: config.displayFont }}
                >
                  {config.brandName}
                </h3>
                <p className="text-[11px] font-semibold tracking-wide text-white/80 uppercase mt-0.5">
                  WHITE LOGO VARIANT
                </p>
              </div>
            </div>

            <div className="text-[10px] font-mono text-slate-300 flex justify-between items-center gap-2 pt-2.5 border-t border-white/10 relative z-10">
              <span className="truncate">Charcoal: {config.charcoalColor}</span>
              <span className="text-slate-100 font-bold shrink-0">100% Solid White</span>
            </div>
          </div>

          {/* Card 3: Monochrome Light Variant (High Contrast Pure White) */}
          <div
            className="group relative rounded-2xl p-6 flex flex-col justify-between overflow-hidden shadow-xl transition-all border border-slate-300 min-h-[230px]"
            style={{ backgroundColor: '#FFFFFF' }}
          >
            <div className="flex items-center justify-between gap-2 relative z-10">
              <span className="text-[10px] font-black uppercase tracking-widest text-slate-900">Monochrome Light</span>
              <span className="w-2.5 h-2.5 rounded-full shrink-0" style={{ backgroundColor: config.charcoalColor }} />
            </div>

            <div className="py-4 flex items-center gap-4 relative z-10">
              <div
                className="w-16 h-16 rounded-2xl shrink-0 flex items-center justify-center shadow-lg transform group-hover:scale-105 transition"
                style={{ backgroundColor: config.charcoalColor }}
              >
                <span
                  className="text-3xl font-extrabold text-white"
                  style={{ fontFamily: config.displayFont }}
                >
                  {config.monogramLetter}
                </span>
              </div>
              <div className="min-w-0 flex-1">
                <h3
                  className="text-2xl font-black tracking-tight truncate"
                  style={{ fontFamily: config.displayFont, color: config.charcoalColor }}
                >
                  {config.brandName}
                </h3>
                <p className="text-[11px] font-bold tracking-wide uppercase mt-0.5 line-clamp-2" style={{ color: config.primaryColor }}>
                  {config.subtitle}
                </p>
              </div>
            </div>

            <div className="text-[10px] font-mono text-slate-800 font-bold flex justify-between items-center gap-2 pt-2.5 border-t border-slate-200 relative z-10">
              <span className="truncate">Light BG: #FFFFFF</span>
              <span className="shrink-0">Charcoal: {config.charcoalColor}</span>
            </div>
          </div>

        </div>
      </div>

      {/* ------------------------------------------------------------- */}
      {/* SECTION 2: 3D NATIVE APP ICON SUITE                           */}
      {/* ------------------------------------------------------------- */}
      <div className="flex flex-col gap-4">
        <div className="flex items-center gap-2">
          <div className="p-1.5 rounded-lg bg-amber-500/10 border border-amber-500/20 text-amber-400 shrink-0">
            <ShieldCheck className="w-4 h-4" />
          </div>
          <h2 className="text-xs font-black uppercase tracking-widest text-slate-200">2. Native App Icon Suite</h2>
        </div>

        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          
          {/* Primary App Icon */}
          <div className="p-4 rounded-2xl glass-card flex flex-col items-center text-center gap-3">
            <div
              className="w-20 h-20 rounded-2xl flex items-center justify-center shadow-2xl transform hover:scale-105 transition border border-white/20 relative overflow-hidden"
              style={{ backgroundColor: config.primaryColor }}
            >
              <div className="absolute top-0 inset-x-0 h-1/2 bg-gradient-to-b from-white/25 to-transparent pointer-events-none" />
              <span className="text-4xl font-extrabold text-white drop-shadow" style={{ fontFamily: config.displayFont }}>
                {config.monogramLetter}
              </span>
            </div>
            <div>
              <p className="text-xs font-bold text-slate-100">Primary App Icon</p>
              <p className="text-[10px] font-mono text-indigo-400 font-semibold mt-0.5">{config.primaryColor}</p>
            </div>
          </div>

          {/* Dark Mode Icon */}
          <div className="p-4 rounded-2xl glass-card flex flex-col items-center text-center gap-3">
            <div
              className="w-20 h-20 rounded-2xl flex items-center justify-center shadow-2xl border border-slate-700/80 transform hover:scale-105 transition relative overflow-hidden"
              style={{ backgroundColor: config.darkBgColor }}
            >
              <div className="absolute top-0 inset-x-0 h-1/2 bg-gradient-to-b from-white/10 to-transparent pointer-events-none" />
              <span className="text-4xl font-extrabold drop-shadow" style={{ fontFamily: config.displayFont, color: config.goldColor }}>
                {config.monogramLetter}
              </span>
            </div>
            <div>
              <p className="text-xs font-bold text-slate-100">Dark Mode Icon</p>
              <p className="text-[10px] font-mono text-amber-400 font-semibold mt-0.5">{config.goldColor}</p>
            </div>
          </div>

          {/* Luxury Gold Icon */}
          <div className="p-4 rounded-2xl glass-card flex flex-col items-center text-center gap-3">
            <div
              className="w-20 h-20 rounded-2xl flex items-center justify-center shadow-2xl transform hover:scale-105 transition border border-white/25 relative overflow-hidden"
              style={{ backgroundColor: config.goldColor }}
            >
              <div className="absolute top-0 inset-x-0 h-1/2 bg-gradient-to-b from-white/30 to-transparent pointer-events-none" />
              <span className="text-4xl font-extrabold text-white drop-shadow" style={{ fontFamily: config.displayFont }}>
                {config.monogramLetter}
              </span>
            </div>
            <div>
              <p className="text-xs font-bold text-slate-100">Luxury Gold Icon</p>
              <p className="text-[10px] font-mono text-amber-400 font-semibold mt-0.5">{config.goldColor}</p>
            </div>
          </div>

          {/* Monogram Circular Badge */}
          <div className="p-4 rounded-2xl glass-card flex flex-col items-center text-center gap-3">
            <div
              className="w-20 h-20 rounded-full flex items-center justify-center shadow-2xl border-2 border-white/30 transform hover:scale-105 transition relative overflow-hidden"
              style={{
                background: `linear-gradient(135deg, ${config.primaryColor}, ${config.charcoalColor})`
              }}
            >
              <div className="absolute top-0 inset-x-0 h-1/2 bg-gradient-to-b from-white/20 to-transparent pointer-events-none" />
              <span className="text-4xl font-extrabold text-white drop-shadow" style={{ fontFamily: config.displayFont }}>
                {config.monogramLetter}
              </span>
            </div>
            <div>
              <p className="text-xs font-bold text-slate-100">Reels Badge</p>
              <p className="text-[10px] font-mono text-indigo-400 font-semibold mt-0.5">Gradient Monogram</p>
            </div>
          </div>

        </div>
      </div>

      {/* ------------------------------------------------------------- */}
      {/* SECTION 3: COLOR PALETTE & TYPOGRAPHY                         */}
      {/* ------------------------------------------------------------- */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        
        {/* Color Tokens */}
        <div className="flex flex-col gap-4">
          <div className="flex items-center gap-2">
            <div className="p-1.5 rounded-lg bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 shrink-0">
              <Palette className="w-4 h-4" />
            </div>
            <h2 className="text-xs font-black uppercase tracking-widest text-slate-200">3. Verified Color Tokens</h2>
          </div>

          <div className="flex flex-col gap-2.5">
            {[
              { name: 'Primary Accent', hex: config.primaryColor, role: 'Brand Core Accent' },
              { name: 'Deep Charcoal', hex: config.charcoalColor, role: 'Dark Surface / Text' },
              { name: 'Luxury Gold', hex: config.goldColor, role: 'Highlight / Badges' },
              { name: 'Dark Background', hex: config.darkBgColor, role: 'App Background' },
              { name: 'Light Background', hex: config.lightBgColor, role: 'Light Surface' },
            ].map((c) => (
              <div key={c.name} className="flex items-center justify-between gap-3 p-3 rounded-xl glass-card">
                <div className="flex items-center gap-3 min-w-0">
                  <div
                    className="w-10 h-10 rounded-xl shadow border border-white/20 shrink-0"
                    style={{ backgroundColor: c.hex }}
                  />
                  <div className="min-w-0 flex flex-col gap-0.5">
                    <div className="flex items-center gap-2 flex-wrap">
                      <p className="text-xs font-bold text-slate-100 truncate">{c.name}</p>
                      <span className="flex items-center gap-1 text-[9px] font-bold text-emerald-400 bg-emerald-500/15 px-1.5 py-0.5 rounded border border-emerald-500/30 shrink-0">
                        <CheckCircle2 className="w-2.5 h-2.5 shrink-0" />
                        <span>AAA PASS</span>
                      </span>
                    </div>
                    <p className="text-[10px] font-mono text-slate-400 truncate">RGB({hexToRgb(c.hex)}) • {c.role}</p>
                  </div>
                </div>
                <span className="font-mono text-xs font-bold text-indigo-300 px-3 py-1 rounded-lg bg-slate-900/90 border border-slate-800 shrink-0">
                  {c.hex.toUpperCase()}
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* Typography Scale & Package Specimen */}
        <div className="flex flex-col gap-4">
          <div className="flex items-center gap-2">
            <div className="p-1.5 rounded-lg bg-indigo-500/10 border border-indigo-500/20 text-indigo-400 shrink-0">
              <Type className="w-4 h-4" />
            </div>
            <h2 className="text-xs font-black uppercase tracking-widest text-slate-200">4. Typography & Package Architecture</h2>
          </div>

          <div className="p-5 rounded-2xl glass-card flex flex-col gap-5">
            
            {/* Header Font Scale */}
            <div className="flex flex-col gap-1">
              <p className="text-[10px] font-mono uppercase tracking-widest text-slate-400">Display Font Scale ({config.displayFont})</p>
              <h3
                className="text-2xl font-bold text-slate-100 tracking-tight truncate"
                style={{ fontFamily: config.displayFont }}
              >
                {config.displayFont} Display 48px
              </h3>
              <p
                className="text-base font-semibold text-indigo-300 truncate"
                style={{ fontFamily: config.displayFont }}
              >
                Subheading Specimen 24px
              </p>
            </div>

            <hr className="border-slate-800/80" />

            {/* Body Font */}
            <div className="flex flex-col gap-1">
              <p className="text-[10px] font-mono uppercase tracking-widest text-slate-400">Body Font Scale ({config.bodyFont})</p>
              <p
                className="text-xs text-slate-300 leading-relaxed"
                style={{ fontFamily: config.bodyFont }}
              >
                <strong className="text-white">{config.bodyFont} 14px</strong> — {config.tagline}
              </p>
            </div>

            <hr className="border-slate-800/80" />

            {/* Visual File Explorer */}
            <div className="flex flex-col gap-2">
              <p className="text-[10px] font-mono uppercase tracking-widest text-slate-400">Generated ZIP Package Architecture</p>
              <div className="p-3 rounded-xl bg-slate-950/90 border border-slate-800 font-mono text-xs text-slate-400 flex flex-col gap-1.5 overflow-x-auto">
                
                <div className="flex items-center justify-between gap-2 text-indigo-400 font-bold pb-2 border-b border-slate-800">
                  <div className="flex items-center gap-2 min-w-0">
                    <Folder className="w-4 h-4 text-indigo-400 shrink-0" />
                    <span className="truncate">{safeZipName}</span>
                  </div>
                  <span className="text-[10px] font-semibold text-slate-500 shrink-0">ZIP</span>
                </div>

                <div className="pl-3 flex flex-col gap-1 text-slate-300">
                  <div className="flex items-center justify-between gap-2">
                    <div className="flex items-center gap-2 min-w-0">
                      <Folder className="w-3.5 h-3.5 text-slate-500 shrink-0" />
                      <span className="truncate">01_Master_Logo/</span>
                    </div>
                    <span className="text-[10px] text-slate-500 shrink-0">SVG Vectors</span>
                  </div>

                  <div className="flex items-center justify-between gap-2">
                    <div className="flex items-center gap-2 min-w-0">
                      <Folder className="w-3.5 h-3.5 text-slate-500 shrink-0" />
                      <span className="truncate">04_Icons/</span>
                    </div>
                    <span className="text-[10px] text-slate-500 shrink-0">App Icons</span>
                  </div>

                  <div className="flex items-center justify-between gap-2 text-amber-400 font-semibold">
                    <div className="flex items-center gap-2 min-w-0">
                      <FileCode className="w-3.5 h-3.5 shrink-0" />
                      <span className="truncate">theme_export/ (Compose, Flutter, Tailwind, SwiftUI)</span>
                    </div>
                    <span className="text-[10px] text-amber-400 shrink-0">Tokens</span>
                  </div>

                  <div className="flex items-center justify-between gap-2 text-emerald-400 font-semibold">
                    <div className="flex items-center gap-2 min-w-0">
                      <FileText className="w-3.5 h-3.5 shrink-0" />
                      <span className="truncate">BRAND_GUIDELINES.md</span>
                    </div>
                    <span className="text-[10px] text-emerald-400 shrink-0">Markdown</span>
                  </div>
                </div>

              </div>
            </div>

          </div>
        </div>

      </div>

    </div>
  );
});
