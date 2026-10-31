export interface BrandConfig {
  id: string;
  brandName: string;
  subtitle: string;
  tagline: string;
  primaryColor: string;
  charcoalColor: string;
  goldColor: string;
  darkBgColor: string;
  lightBgColor: string;
  displayFont: string;
  bodyFont: string;
  monogramLetter: string;
  iconShape: 'rounded' | 'circle' | 'squircle';
  industry: string;
  version: string;
}

export const PRESET_BRANDS: Record<string, BrandConfig> = {
  proptreel: {
    id: 'proptreel',
    brandName: 'PropTreel',
    subtitle: 'Luxury Real Estate & Video Showcase Platform',
    tagline: 'Discover Exquisite Properties Through Immersive Reels & AI Search',
    primaryColor: '#6366F1', // Royal Indigo
    charcoalColor: '#1E293B', // Deep Charcoal
    goldColor: '#D97706',     // Warm Amber Gold
    darkBgColor: '#0F172A',   // Midnight Slate
    lightBgColor: '#F8FAFC',  // Pure Platinum
    displayFont: 'Outfit',
    bodyFont: 'Inter',
    monogramLetter: 'P',
    iconShape: 'rounded',
    industry: 'Real Estate SaaS',
    version: '1.2.0',
  },
  aabha: {
    id: 'aabha',
    brandName: 'AABHA',
    subtitle: 'Vedic AI Companion & Spiritual Wellness Assistant',
    tagline: 'Illuminating Ancient Vedic Wisdom with Modern Generative Intelligence',
    primaryColor: '#0EA5E9', // Celestial Blue
    charcoalColor: '#18181B', // Deep Onyx
    goldColor: '#EAB308',     // Sacred Saffron Gold
    darkBgColor: '#090D16',   // Deep Cosmic Void
    lightBgColor: '#FAFAFA',  // Pure Lotus Pearl
    displayFont: 'Cormorant Garamond',
    bodyFont: 'Inter',
    monogramLetter: 'A',
    iconShape: 'circle',
    industry: 'Wellness & AI',
    version: '1.0.0',
  },
  eresto: {
    id: 'eresto',
    brandName: 'eResto Digi Menu',
    subtitle: 'Smart QR Menu & Restaurant Management System',
    tagline: 'Elevate Dining Experiences with Instant Digital Ordering & Analytics',
    primaryColor: '#10B981', // Emerald Mint
    charcoalColor: '#1F2937', // Dark Slate
    goldColor: '#F59E0B',     // Gourmet Honey Gold
    darkBgColor: '#111827',   // Obsidian Dark
    lightBgColor: '#F9FAFB',  // Clean Porcelain
    displayFont: 'Poppins',
    bodyFont: 'Inter',
    monogramLetter: 'E',
    iconShape: 'squircle',
    industry: 'Hospitality Tech',
    version: '2.1.0',
  }
};
