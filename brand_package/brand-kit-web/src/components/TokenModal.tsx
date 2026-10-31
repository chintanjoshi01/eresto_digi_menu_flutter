import React, { useState } from 'react';
import { X, Copy, Check, Code2 } from 'lucide-react';
import type { BrandConfig } from '../types/brand';

interface TokenModalProps {
  isOpen: boolean;
  onClose: () => void;
  config: BrandConfig;
}

export const TokenModal: React.FC<TokenModalProps> = ({ isOpen, onClose, config }) => {
  const [activeTab, setActiveTab] = useState<'compose' | 'flutter' | 'tailwind' | 'swiftui' | 'css'>('compose');
  const [copied, setCopied] = useState(false);

  if (!isOpen) return null;

  const getCodeSnippet = () => {
    switch (activeTab) {
      case 'compose':
        return `// Jetpack Compose Colors: Color.kt
package com.brand.${config.brandName.toLowerCase()}.ui.theme

import androidx.compose.ui.graphics.Color

val ${config.brandName}Primary = Color(0xFF${config.primaryColor.replace('#', '')})
val ${config.brandName}Charcoal = Color(0xFF${config.charcoalColor.replace('#', '')})
val ${config.brandName}Gold = Color(0xFF${config.goldColor.replace('#', '')})
val ${config.brandName}DarkBg = Color(0xFF${config.darkBgColor.replace('#', '')})
val ${config.brandName}LightBg = Color(0xFF${config.lightBgColor.replace('#', '')})`;

      case 'flutter':
        return `// Flutter Colors: brand_theme.dart
import 'package:flutter/material.dart';

class ${config.brandName}BrandColors {
  static const Color primary = Color(0xFF${config.primaryColor.replace('#', '')});
  static const Color charcoal = Color(0xFF${config.charcoalColor.replace('#', '')});
  static const Color gold = Color(0xFF${config.goldColor.replace('#', '')});
  static const Color darkBg = Color(0xFF${config.darkBgColor.replace('#', '')});
  static const Color lightBg = Color(0xFF${config.lightBgColor.replace('#', '')});
}`;

      case 'tailwind':
        return `// Tailwind CSS: tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: {
          primary: '${config.primaryColor}',
          charcoal: '${config.charcoalColor}',
          gold: '${config.goldColor}',
          dark: '${config.darkBgColor}',
          light: '${config.lightBgColor}',
        }
      },
      fontFamily: {
        display: ['${config.displayFont}', 'sans-serif'],
        body: ['${config.bodyFont}', 'sans-serif'],
      }
    }
  }
}`;

      case 'swiftui':
        return `// SwiftUI: ColorTokens.swift
import SwiftUI

public extension Color {
    static let brandPrimary = Color(hex: "${config.primaryColor}")
    static let brandCharcoal = Color(hex: "${config.charcoalColor}")
    static let brandGold = Color(hex: "${config.goldColor}")
    static let brandDarkBg = Color(hex: "${config.darkBgColor}")
    static let brandLightBg = Color(hex: "${config.lightBgColor}")
}`;

      case 'css':
        return `/* CSS Variables: tokens.css */
:root {
  --brand-primary: ${config.primaryColor};
  --brand-charcoal: ${config.charcoalColor};
  --brand-gold: ${config.goldColor};
  --brand-dark-bg: ${config.darkBgColor};
  --brand-light-bg: ${config.lightBgColor};
  --brand-font-display: '${config.displayFont}', sans-serif;
  --brand-font-body: '${config.bodyFont}', sans-serif;
}`;
    }
  };

  const handleCopy = () => {
    navigator.clipboard.writeText(getCodeSnippet());
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-md animate-fade-in">
      <div className="w-full max-w-3xl glass-panel rounded-2xl border border-slate-700/50 shadow-2xl overflow-hidden flex flex-col max-h-[85vh]">
        
        {/* Modal Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-slate-800 bg-slate-900/60">
          <div className="flex items-center space-x-3">
            <div className="p-2 rounded-lg bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">
              <Code2 className="w-5 h-5" />
            </div>
            <div>
              <h3 className="text-lg font-bold text-slate-100">Export Design Theme Tokens</h3>
              <p className="text-xs text-slate-400">Copy pre-formatted code for your preferred development framework</p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-1.5 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Framework Tabs */}
        <div className="flex items-center space-x-2 px-6 py-3 border-b border-slate-800/80 bg-slate-900/30 overflow-x-auto">
          {(['compose', 'flutter', 'tailwind', 'swiftui', 'css'] as const).map((tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`px-4 py-2 rounded-lg text-xs font-semibold capitalize transition ${
                activeTab === tab
                  ? 'bg-indigo-600 text-white shadow-lg shadow-indigo-600/30'
                  : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/60'
              }`}
            >
              {tab === 'compose' ? 'Jetpack Compose' :
               tab === 'flutter' ? 'Flutter' :
               tab === 'tailwind' ? 'Tailwind CSS' :
               tab === 'swiftui' ? 'SwiftUI' : 'CSS Variables'}
            </button>
          ))}
        </div>

        {/* Code View Area */}
        <div className="relative flex-1 p-6 bg-slate-950 overflow-auto font-mono text-sm">
          <button
            onClick={handleCopy}
            className="absolute top-4 right-4 flex items-center space-x-2 px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-xs font-sans text-slate-200 border border-slate-700 transition shadow-md"
          >
            {copied ? (
              <>
                <Check className="w-4 h-4 text-emerald-400" />
                <span className="text-emerald-400 font-medium">Copied!</span>
              </>
            ) : (
              <>
                <Copy className="w-4 h-4" />
                <span>Copy Code</span>
              </>
            )}
          </button>
          <pre className="text-slate-300 leading-relaxed overflow-x-auto selection:bg-indigo-500/30">
            <code>{getCodeSnippet()}</code>
          </pre>
        </div>

        {/* Modal Footer */}
        <div className="flex items-center justify-between px-6 py-4 border-t border-slate-800 bg-slate-900/60">
          <span className="text-xs text-slate-400">
            Brand Kit v{config.version} • {config.brandName}
          </span>
          <button
            onClick={onClose}
            className="px-4 py-2 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-semibold transition"
          >
            Close
          </button>
        </div>

      </div>
    </div>
  );
};
