import React from 'react';
import { Palette, Type, Layers, Sparkles, Download, Code2, Camera } from 'lucide-react';
import { type BrandConfig, PRESET_BRANDS } from '../types/brand';

interface ConfigPanelProps {
  config: BrandConfig;
  onChange: (updated: BrandConfig) => void;
  onDownloadZip: () => void;
  onOpenTokens: () => void;
  onExportPng: () => void;
}

export const ConfigPanel: React.FC<ConfigPanelProps> = ({
  config,
  onChange,
  onDownloadZip,
  onOpenTokens,
  onExportPng
}) => {

  const handleFieldChange = (key: keyof BrandConfig, value: any) => {
    onChange({
      ...config,
      [key]: value
    });
  };

  const applyPreset = (presetKey: string) => {
    if (PRESET_BRANDS[presetKey]) {
      onChange(PRESET_BRANDS[presetKey]);
    }
  };

  return (
    <aside className="w-full lg:w-80 shrink-0 glass-panel border-r border-slate-800/80 p-5 flex flex-col gap-5 overflow-y-auto max-h-screen">
      
      {/* 1. Header */}
      <div className="flex items-center gap-3 pb-3 border-b border-slate-800/80">
        <div className="w-8 h-8 rounded-xl bg-gradient-to-tr from-indigo-600 to-amber-500 flex items-center justify-center shadow-lg shadow-indigo-500/20 shrink-0">
          <Sparkles className="w-4 h-4 text-white" />
        </div>
        <div>
          <h2 className="text-sm font-extrabold text-slate-100 tracking-tight">Brand Identity Controls</h2>
          <p className="text-[10px] text-indigo-400 font-medium">Antigravity AI Engine v1.2</p>
        </div>
      </div>

      {/* 2. Presets Selector */}
      <div className="flex flex-col gap-2">
        <label className="text-[11px] font-bold text-slate-400 uppercase tracking-wider flex items-center gap-1.5">
          <Layers className="w-3.5 h-3.5 text-indigo-400 shrink-0" />
          <span>Verified Brand Presets</span>
        </label>
        <div className="flex flex-col gap-2">
          {Object.entries(PRESET_BRANDS).map(([key, brand]) => (
            <button
              key={key}
              onClick={() => applyPreset(key)}
              className={`p-2.5 rounded-xl text-left border transition-all flex items-center justify-between gap-2 ${
                config.id === key
                  ? 'bg-indigo-600/20 border-indigo-500/80 text-white shadow-md shadow-indigo-600/10'
                  : 'bg-slate-900/50 border-slate-800 text-slate-400 hover:border-slate-700 hover:text-slate-200'
              }`}
            >
              <div className="flex items-center gap-2.5 min-w-0">
                <span
                  className="w-3.5 h-3.5 rounded-full shrink-0 border border-white/20 shadow-sm"
                  style={{ backgroundColor: brand.primaryColor }}
                />
                <div className="min-w-0">
                  <p className="text-xs font-bold text-slate-100 truncate">{brand.brandName}</p>
                  <p className="text-[10px] text-slate-400 truncate">{brand.industry}</p>
                </div>
              </div>
              <span className="text-[10px] font-mono font-medium px-2 py-0.5 rounded bg-slate-950/80 text-indigo-300 border border-slate-800 shrink-0">
                v{brand.version}
              </span>
            </button>
          ))}
        </div>
      </div>

      <hr className="border-slate-800/80" />

      {/* 3. Brand Identity Fields */}
      <div className="flex flex-col gap-3">
        <label className="text-[11px] font-bold text-slate-400 uppercase tracking-wider flex items-center gap-1.5">
          <Type className="w-3.5 h-3.5 text-indigo-400 shrink-0" />
          <span>Brand Identity</span>
        </label>

        <div className="flex flex-col gap-3">
          <div>
            <label className="text-[11px] text-slate-400 font-medium">Brand Name</label>
            <input
              type="text"
              value={config.brandName}
              onChange={(e) => handleFieldChange('brandName', e.target.value)}
              className="w-full mt-1 glass-input text-sm"
              placeholder="e.g. PropTreel"
            />
          </div>

          <div>
            <label className="text-[11px] text-slate-400 font-medium">Subtitle / Category</label>
            <input
              type="text"
              value={config.subtitle}
              onChange={(e) => handleFieldChange('subtitle', e.target.value)}
              className="w-full mt-1 glass-input text-sm"
              placeholder="e.g. Real Estate Video Platform"
            />
          </div>

          <div>
            <label className="text-[11px] text-slate-400 font-medium">Tagline / Pitch</label>
            <textarea
              rows={2}
              value={config.tagline}
              onChange={(e) => handleFieldChange('tagline', e.target.value)}
              className="w-full mt-1 glass-input text-xs resize-none"
              placeholder="e.g. Discover Exquisite Properties..."
            />
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="text-[11px] text-slate-400 font-medium">Monogram</label>
              <input
                type="text"
                maxLength={2}
                value={config.monogramLetter}
                onChange={(e) => handleFieldChange('monogramLetter', e.target.value.toUpperCase())}
                className="w-full mt-1 glass-input text-center font-bold uppercase"
              />
            </div>

            <div>
              <label className="text-[11px] text-slate-400 font-medium">Display Font</label>
              <select
                value={config.displayFont}
                onChange={(e) => handleFieldChange('displayFont', e.target.value)}
                className="w-full mt-1 glass-input text-xs bg-slate-900"
              >
                <option value="Outfit">Outfit (Modern)</option>
                <option value="Cormorant Garamond">Cormorant (Serif)</option>
                <option value="Poppins">Poppins (Clean)</option>
                <option value="Inter">Inter (Minimal)</option>
              </select>
            </div>
          </div>
        </div>
      </div>

      <hr className="border-slate-800/80" />

      {/* 4. Color Palette Pickers */}
      <div className="flex flex-col gap-3">
        <label className="text-[11px] font-bold text-slate-400 uppercase tracking-wider flex items-center gap-1.5">
          <Palette className="w-3.5 h-3.5 text-amber-400 shrink-0" />
          <span>Color Tokens</span>
        </label>

        <div className="flex flex-col gap-2">
          {[
            { label: 'Primary Accent', key: 'primaryColor' as keyof BrandConfig },
            { label: 'Deep Charcoal', key: 'charcoalColor' as keyof BrandConfig },
            { label: 'Gold Accent', key: 'goldColor' as keyof BrandConfig },
            { label: 'Dark Background', key: 'darkBgColor' as keyof BrandConfig },
            { label: 'Light Background', key: 'lightBgColor' as keyof BrandConfig },
          ].map(({ label, key }) => (
            <div key={key} className="flex items-center justify-between gap-3 p-2 rounded-xl bg-slate-900/60 border border-slate-800/80 hover:border-slate-700 transition">
              <div className="flex items-center gap-2.5 min-w-0">
                <div
                  className="w-7 h-7 rounded-lg relative overflow-hidden border border-white/20 shadow-inner flex items-center justify-center shrink-0 cursor-pointer"
                  style={{ backgroundColor: config[key] as string }}
                >
                  <input
                    type="color"
                    value={config[key] as string}
                    onChange={(e) => handleFieldChange(key, e.target.value)}
                    className="absolute inset-0 opacity-0 w-full h-full cursor-pointer"
                  />
                </div>
                <span className="text-xs font-medium text-slate-300 truncate">{label}</span>
              </div>
              <input
                type="text"
                value={config[key] as string}
                onChange={(e) => handleFieldChange(key, e.target.value)}
                className="w-20 text-center font-mono text-xs glass-input p-1 text-indigo-300 font-bold shrink-0"
              />
            </div>
          ))}
        </div>
      </div>

      {/* 5. Bottom Action Buttons */}
      <div className="pt-3 mt-auto flex flex-col gap-2.5">
        <button
          onClick={onDownloadZip}
          className="w-full flex items-center justify-center gap-2 py-3 px-4 rounded-xl bg-gradient-to-r from-indigo-600 via-indigo-500 to-amber-500 hover:from-indigo-500 hover:to-amber-400 text-white font-extrabold text-xs shadow-lg shadow-indigo-600/30 transition transform hover:-translate-y-0.5 active:translate-y-0"
        >
          <Download className="w-4 h-4 shrink-0" />
          <span>Download Brand Kit (.ZIP)</span>
        </button>

        <div className="grid grid-cols-2 gap-2">
          <button
            onClick={onOpenTokens}
            className="flex items-center justify-center gap-1.5 py-2 px-3 rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700/80 text-xs font-semibold transition"
          >
            <Code2 className="w-3.5 h-3.5 text-indigo-400 shrink-0" />
            <span>Code Tokens</span>
          </button>

          <button
            onClick={onExportPng}
            className="flex items-center justify-center gap-1.5 py-2 px-3 rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700/80 text-xs font-semibold transition"
          >
            <Camera className="w-3.5 h-3.5 text-amber-400 shrink-0" />
            <span>Save 4K PNG</span>
          </button>
        </div>
      </div>

    </aside>
  );
};
