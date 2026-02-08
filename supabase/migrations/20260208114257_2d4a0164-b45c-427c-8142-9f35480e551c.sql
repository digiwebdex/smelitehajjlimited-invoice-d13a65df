-- Add branding fields to companies table
ALTER TABLE public.companies
ADD COLUMN IF NOT EXISTS tagline TEXT,
ADD COLUMN IF NOT EXISTS address_line1 TEXT,
ADD COLUMN IF NOT EXISTS address_line2 TEXT,
ADD COLUMN IF NOT EXISTS website TEXT,
ADD COLUMN IF NOT EXISTS thank_you_text TEXT DEFAULT 'Thank you for staying with us.',
ADD COLUMN IF NOT EXISTS show_qr_code BOOLEAN DEFAULT true,
ADD COLUMN IF NOT EXISTS footer_alignment TEXT DEFAULT 'center';

-- Update existing companies with default values
UPDATE public.companies 
SET 
  address_line1 = COALESCE(address, ''),
  thank_you_text = 'Thank you for staying with us.',
  show_qr_code = true,
  footer_alignment = 'center'
WHERE thank_you_text IS NULL;