import React from 'react';
import { Palette, Download, Code2, ExternalLink, Sparkles } from 'lucide-react';

interface NavbarProps {
  onDownloadZip: () => void;
  onOpenTokens: () => void;
}

export const Navbar: React.FC<NavbarProps> = ({ onDownloadZip, onOpenTokens }) => {
  return (
    <header className="sticky top-0 z-40 w-full glass-panel border-b border-slate-800/80 px-6 py-3 flex items-center justify-between gap-4 backdrop-blur-xl bg-slate-950/90 shadow-lg">
      
      {/* 1. Left Logo & Brand Title */}
      <div className="flex items-center gap-3 shrink-0">
        <div className="relative shrink-0">
          <div className="w-9 h-9 rounded-xl bg-gradient-to-tr from-indigo-600 via-indigo-500 to-amber-500 flex items-center justify-center shadow-lg shadow-indigo-500/25">
            <Palette className="w-5 h-5 text-white" />
          </div>
          <span className="absolute -bottom-0.5 -right-0.5 w-3 h-3 rounded-full bg-emerald-500 border-2 border-slate-950 shadow-sm" />
        </div>
        
        <div className="flex items-center gap-2 flex-wrap">
          <h1 className="text-base font-black text-slate-100 tracking-tight whitespace-nowrap">
            Brand Kit Studio
          </h1>
          <span className="px-2 py-0.5 rounded-full text-[10px] font-extrabold bg-indigo-500/20 text-indigo-300 border border-indigo-500/40 uppercase tracking-wider">
            PRO SaaS
          </span>
          <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-slate-800 text-slate-400 border border-slate-700 font-mono">
            v1.2.0
          </span>
        </div>
      </div>

      {/* 2. Center Nav Badges */}
      <div className="hidden md:flex items-center gap-3 shrink-0">
        <a
          href="https://open-vsx.org/extension/chintanjoshi/antigravity-brand-kit-creator"
          target="_blank"
          rel="noopener noreferrer"
          className="flex items-center gap-2 px-3 py-1.5 rounded-xl bg-slate-900/90 hover:bg-slate-800 text-slate-300 text-xs font-semibold border border-slate-800 transition-all hover:border-slate-700 shadow-sm group"
        >
          <Sparkles className="w-3.5 h-3.5 text-amber-400 group-hover:rotate-12 transition-transform shrink-0" />
          <span>Open VSX Extension</span>
          <ExternalLink className="w-3 h-3 text-slate-500 group-hover:text-slate-300 transition-colors shrink-0" />
        </a>

        <a
          href="https://github.com/chintanjoshi01/antigravity-brand-kit-creator"
          target="_blank"
          rel="noopener noreferrer"
          className="flex items-center gap-2 px-3 py-1.5 rounded-xl bg-slate-900/90 hover:bg-slate-800 text-slate-300 text-xs font-semibold border border-slate-800 transition-all hover:border-slate-700 shadow-sm group"
        >
          <svg className="w-3.5 h-3.5 shrink-0 fill-current text-slate-400 group-hover:text-slate-200" viewBox="0 0 24 24">
            <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z"/>
          </svg>
          <span>GitHub</span>
          <ExternalLink className="w-3 h-3 text-slate-500 group-hover:text-slate-300 transition-colors shrink-0" />
        </a>
      </div>

      {/* 3. Right Action Buttons */}
      <div className="flex items-center gap-2.5 shrink-0">
        <button
          onClick={onOpenTokens}
          className="hidden sm:flex items-center gap-2 px-3.5 py-2 rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 text-xs font-bold border border-slate-700/80 transition-all shadow-sm hover:border-slate-600"
        >
          <Code2 className="w-4 h-4 text-indigo-400 shrink-0" />
          <span>Code Tokens</span>
        </button>

        <button
          onClick={onDownloadZip}
          className="flex items-center gap-2 px-4 py-2 rounded-xl bg-gradient-to-r from-indigo-600 via-indigo-500 to-amber-500 hover:from-indigo-500 hover:to-amber-400 text-white text-xs font-extrabold shadow-lg shadow-indigo-600/25 transition-all transform hover:-translate-y-0.5 active:translate-y-0"
        >
          <Download className="w-4 h-4 shrink-0" />
          <span>Export Package (.ZIP)</span>
        </button>
      </div>

    </header>
  );
};
