/*
  # Add Demo Mock Data

  1. Mock Data Added
    - Institution authorization request (approved) for demo institution
    - Student profile for demo student
    - Sample credentials (2 examples)
    - Audit logs for credential activities
    - Promo code for free access

  2. Demo Users
    - Institution: 0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1
    - Student: 0x9876543210abcdef9876543210abcdef98765432
    - Admin: 0x1234567890abcdef1234567890abcdef12345678

  3. Security
    - Mock data only - safe for demo environment
    - No real sensitive information
*/

-- Insert approved institution authorization request
INSERT INTO institution_authorization_requests (
  id,
  institution_name,
  wallet_address,
  email,
  phone,
  description,
  status,
  admin_notes,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'Harvard University',
  '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1',
  'institution@university.edu',
  '+1-617-495-1000',
  'Harvard University is a private Ivy League research university in Cambridge, Massachusetts. Established in 1636, it is the oldest institution of higher learning in the United States.',
  'approved',
  'Verified institution credentials. Authorization granted for credential issuance.',
  NOW() - INTERVAL '7 days',
  NOW() - INTERVAL '6 days'
) ON CONFLICT DO NOTHING;

-- Insert student profile
INSERT INTO student_profiles (
  id,
  wallet_address,
  full_name,
  email,
  institution_name,
  institution_address,
  enrollment_date,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  '0x9876543210abcdef9876543210abcdef98765432',
  'John Doe',
  'student@university.edu',
  'Harvard University',
  '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1',
  NOW() - INTERVAL '4 years',
  NOW() - INTERVAL '4 years',
  NOW()
) ON CONFLICT DO NOTHING;

-- Insert sample credentials
DO $$
DECLARE
  cred_1_id UUID;
  cred_2_id UUID;
BEGIN
  -- Credential 1: Bachelor's Degree
  INSERT INTO credentials (
    id,
    token_id,
    student_address,
    institution_name,
    institution_address,
    degree,
    ipfs_hash,
    issue_date,
    revoked,
    created_at,
    updated_at
  ) VALUES (
    gen_random_uuid(),
    '1001',
    '0x9876543210abcdef9876543210abcdef98765432',
    'Harvard University',
    '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1',
    'Bachelor of Science in Computer Science (2024)',
    'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG',
    NOW() - INTERVAL '2 months',
    false,
    NOW() - INTERVAL '2 months',
    NOW() - INTERVAL '2 months'
  )
  ON CONFLICT (token_id) DO NOTHING
  RETURNING id INTO cred_1_id;

  -- Credential 2: Master's Degree
  INSERT INTO credentials (
    id,
    token_id,
    student_address,
    institution_name,
    institution_address,
    degree,
    ipfs_hash,
    issue_date,
    revoked,
    created_at,
    updated_at
  ) VALUES (
    gen_random_uuid(),
    '1002',
    '0x9876543210abcdef9876543210abcdef98765432',
    'Harvard University',
    '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1',
    'Master of Science in Data Science (2024)',
    'QmT4AeWE9Q58EzeR85W8xbMDpXt8fKRGYPFkGhHqwK3EmU',
    NOW() - INTERVAL '1 month',
    false,
    NOW() - INTERVAL '1 month',
    NOW() - INTERVAL '1 month'
  )
  ON CONFLICT (token_id) DO NOTHING
  RETURNING id INTO cred_2_id;

  -- Add audit logs for credential 1
  IF cred_1_id IS NOT NULL THEN
    INSERT INTO audit_logs (
      id,
      credential_id,
      action,
      actor_address,
      metadata,
      created_at
    ) VALUES
    (
      gen_random_uuid(),
      cred_1_id,
      'issued',
      '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1',
      jsonb_build_object(
        'tokenId', '1001',
        'degree', 'Bachelor of Science in Computer Science (2024)',
        'institutionName', 'Harvard University'
      ),
      NOW() - INTERVAL '2 months'
    ),
    (
      gen_random_uuid(),
      cred_1_id,
      'verified',
      '0x5555666677778888999900001111222233334444',
      jsonb_build_object('verifiedBy', 'MIT Admissions Office'),
      NOW() - INTERVAL '1 month'
    ),
    (
      gen_random_uuid(),
      cred_1_id,
      'shared',
      '0x9876543210abcdef9876543210abcdef98765432',
      jsonb_build_object('sharedWith', 'Stanford University'),
      NOW() - INTERVAL '3 weeks'
    )
    ON CONFLICT DO NOTHING;
  END IF;

  -- Add audit logs for credential 2
  IF cred_2_id IS NOT NULL THEN
    INSERT INTO audit_logs (
      id,
      credential_id,
      action,
      actor_address,
      metadata,
      created_at
    ) VALUES
    (
      gen_random_uuid(),
      cred_2_id,
      'issued',
      '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1',
      jsonb_build_object(
        'tokenId', '1002',
        'degree', 'Master of Science in Data Science (2024)',
        'institutionName', 'Harvard University'
      ),
      NOW() - INTERVAL '1 month'
    ),
    (
      gen_random_uuid(),
      cred_2_id,
      'verified',
      '0xaaaaaabbbbbbccccccddddddeeeeeeffffffffff',
      jsonb_build_object('verifiedBy', 'Google HR Department'),
      NOW() - INTERVAL '2 weeks'
    )
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- Add TRINETRA promo code if not exists
INSERT INTO promo_codes (
  id,
  code,
  discount_type,
  discount_value,
  valid_from,
  valid_until,
  max_uses,
  current_uses,
  applicable_to,
  active,
  created_at
) VALUES (
  gen_random_uuid(),
  'TRINETRA',
  'percentage',
  100,
  NOW() - INTERVAL '30 days',
  NOW() + INTERVAL '1 year',
  1000,
  0,
  ARRAY['institution', 'employer']::text[],
  true,
  NOW() - INTERVAL '30 days'
)
ON CONFLICT (code) DO UPDATE SET
  active = true,
  valid_until = NOW() + INTERVAL '1 year';

-- Add another institution authorization request (pending) for demo
INSERT INTO institution_authorization_requests (
  id,
  institution_name,
  wallet_address,
  email,
  phone,
  description,
  status,
  admin_notes,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'MIT (Massachusetts Institute of Technology)',
  '0xabcdef1234567890abcdef1234567890abcdef12',
  'admin@mit.edu',
  '+1-617-253-1000',
  'MIT is a private research university in Cambridge, Massachusetts. The institute is renowned for its excellence in science, technology, and research.',
  'pending',
  NULL,
  NOW() - INTERVAL '2 days',
  NOW() - INTERVAL '2 days'
) ON CONFLICT DO NOTHING;