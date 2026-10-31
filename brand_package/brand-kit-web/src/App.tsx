import React, { useState, useRef } from 'react';
import { toPng } from 'html-to-image';
import { saveAs } from 'file-saver';
import { type BrandConfig, PRESET_BRANDS } from './types/brand';
import { Navbar } from './components/Navbar';
import { ConfigPanel } from './components/ConfigPanel';
import { ShowcaseBoard } from './components/ShowcaseBoard';
import { TokenModal } from './components/TokenModal';
import { generateBrandKitZip } from './utils/zipGenerator';

export const App: React.FC = () => {
  const [config, setConfig] = useState<BrandConfig>(PRESET_BRANDS.proptreel);
  const [isTokenModalOpen, setIsTokenModalOpen] = useState<boolean>(false);
  const showcaseRef = useRef<HTMLDivElement>(null);

  const handleDownloadZip = () => {
    generateBrandKitZip(config);
  };

  const handleExportPng = async () => {
    if (showcaseRef.current) {
      try {
        const dataUrl = await toPng(showcaseRef.current, { cacheBust: true, pixelRatio: 2 });
        saveAs(dataUrl, `${config.brandName}_Showcase_Board_v${config.version}.png`);
      } catch (err) {
        console.error('Failed to export PNG showcase:', err);
      }
    }
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col font-sans selection:bg-indigo-500 selection:text-white">
      
      {/* Top Header */}
      <Navbar
        onDownloadZip={handleDownloadZip}
        onOpenTokens={() => setIsTokenModalOpen(true)}
      />

      {/* Main App Layout */}
      <div className="flex-1 flex flex-col lg:flex-row overflow-hidden">
        
        {/* Left Control Sidebar */}
        <ConfigPanel
          config={config}
          onChange={setConfig}
          onDownloadZip={handleDownloadZip}
          onOpenTokens={() => setIsTokenModalOpen(true)}
          onExportPng={handleExportPng}
        />

        {/* Right Main Live Showcase Canvas Area */}
        <main className="flex-1 p-6 md:p-10 overflow-y-auto bg-slate-950 flex flex-col items-center justify-start">
          <ShowcaseBoard
            ref={showcaseRef}
            config={config}
          />
        </main>
      </div>

      {/* Code Tokens Modal */}
      <TokenModal
        isOpen={isTokenModalOpen}
        onClose={() => setIsTokenModalOpen(false)}
        config={config}
      />

    </div>
  );
};

export default App;
