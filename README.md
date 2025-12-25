# ZK Ledger - Blockchain Academic Credentials Platform

A decentralized platform for issuing, managing, and verifying tamper-proof academic credentials using blockchain technology and Soulbound Tokens (SBTs).

## Overview

ZK Ledger is a comprehensive solution for digital academic credential management that leverages blockchain technology to ensure credentials are secure, verifiable, and non-transferable. The platform serves students, educational institutions, employers, and administrators.

## Key Features

### For Students
- Connect wallet to view all academic credentials
- 3D interactive credential showcase with Grid/Stack/Focus views
- Generate QR codes for instant verification
- Create time-limited share links for employers/universities
- Track credential access history and audit logs
- Free unlimited access forever

### For Institutions
- Issue blockchain-verified credentials to students
- Upload supporting documents (PDF, PNG, JPG) to IPFS
- Manage issued credentials dashboard
- View registered students
- Revoke credentials when necessary
- Subscription-based access (Basic/Pro/Enterprise)

### For Employers/Verifiers
- Instant credential verification via token ID or QR code
- View complete credential history and blockchain proof
- Access IPFS-stored documents
- Free verifications (3 free, then subscription required)

### For Administrators
- Review and approve institution authorization requests
- Manage platform subscriptions and promo codes
- Monitor system health and operations dashboard
- View real-time audit logs and analytics
- AI-powered assistant for platform queries

## Technology Stack

### Blockchain & Web3
- **Ethereum Sepolia Testnet** - Smart contract deployment and credential minting
- **Ethers.js v6** - Web3 library for blockchain interactions
- **MetaMask** - Wallet connection and transaction signing
- **Solidity** - Smart contract development (ERC-721 Soulbound Tokens)

### Frontend
- **React 18** - UI framework
- **TypeScript** - Type-safe development
- **Vite** - Build tool and dev server
- **TailwindCSS** - Utility-first styling
- **Framer Motion** - Animations and 3D effects
- **Recharts** - Data visualization
- **Lucide React** - Icon library
- **QRCode.react** - QR code generation

### Backend & Storage
- **Supabase** - PostgreSQL database with Row Level Security
- **IPFS (Pinata)** - Decentralized document storage
- **Supabase Edge Functions** - Serverless functions (if needed)

### Development Tools
- **ESLint** - Code linting
- **PostCSS & Autoprefixer** - CSS processing
- **TypeScript ESLint** - Type checking

## Google Technologies

### Currently Used
This project **does NOT currently use any Google technologies** such as:
- Firebase (Authentication, Firestore, Storage, Hosting)
- Google Cloud Platform (Cloud Functions, Cloud Storage, Compute Engine)
- Google Cloud SQL
- Google Analytics
- Google AI Studio / Vertex AI
- Google Cloud Vision API
- Google Cloud Identity Platform

### Technology Choices
We opted for alternative solutions:
- **Supabase** instead of Firebase (for PostgreSQL benefits and better SQL support)
- **IPFS (Pinata)** instead of Google Cloud Storage (for decentralized, censorship-resistant storage)
- **Ethereum blockchain** for immutable record-keeping
- **Custom AI assistant** instead of Google AI Studio (embedded knowledge base)

### Potential Future Integrations
Google technologies that could be integrated:
1. **Firebase Cloud Messaging (FCM)** - Push notifications for credential updates
2. **Google Analytics** - Enhanced user behavior tracking
3. **Google Cloud Vision API** - Automated document verification and OCR
4. **Google Cloud Translation API** - Multi-language support for international credentials
5. **Google Identity Services** - Additional SSO authentication method
6. **Google Cloud Functions** - Additional serverless compute for heavy operations
7. **Google BigQuery** - Advanced analytics and data warehousing
8. **Google Cloud Armor** - DDoS protection and security

## Architecture

### Smart Contract (Solidity)
```
AcademicCredentials.sol
├── ERC-721 Soulbound Token implementation
├── Non-transferable credential NFTs
├── Institution authorization system
├── Credential issuance and revocation
└── On-chain metadata storage
```

### Database Schema (Supabase PostgreSQL)
```
- credentials (token_id, student_address, institution_address, degree, ipfs_hash, revoked)
- credential_shares (share_token, expires_at, access_count)
- audit_logs (action, actor_address, metadata, created_at)
- institution_authorization_requests (status, wallet_address, institution_name)
- student_profiles (wallet_address, full_name, email, institution_name)
- pricing_plans (plan_type, price, features)
- user_subscriptions (user_address, plan_id, status, expires_at)
- payment_transactions (amount, promo_code, discount_applied, status)
- promo_codes (code, discount_value, discount_type, applicable_to)
```

### IPFS Storage
- Documents uploaded to Pinata gateway
- Content-addressed via IPFS hash
- Immutable and tamper-proof
- Publicly accessible via gateway URL

## Installation & Setup

### Prerequisites
- Node.js 18+ and npm
- MetaMask browser extension
- Git

### Quick Start

1. **Clone the repository**
```bash
git clone <repository-url>
cd project
```

2. **Install dependencies**
```bash
npm install
```

3. **Environment Variables**
The `.env` file is already configured with:
```env
VITE_SUPABASE_URL=https://xusxocwdxemozzwmkyap.supabase.co
VITE_SUPABASE_ANON_KEY=<your-key>
VITE_PINATA_JWT=<your-key>
VITE_PINATA_GATEWAY=https://gateway.pinata.cloud
```

4. **Start development server**
```bash
npm run dev
```

5. **Open in browser**
```
http://localhost:5173
```

### Get Testnet ETH
1. Visit https://sepoliafaucet.com
2. Paste your MetaMask wallet address
3. Receive 0.5 Sepolia ETH (free)

## Demo Credentials

### Admin
```
Email: admin@acadchain.com
Password: admin123
```

### Institution
```
Email: institution@university.edu
Password: inst123
```

### Student
```
Email: student@university.edu
Password: student123
```

### Employer/Verifier
```
Email: verifier@employer.com
Password: verify123
```

### Promo Code
```
Code: TRINETRA
Benefit: Free subscription access
```

## Smart Contract Details

**Deployed on Ethereum Sepolia Testnet**

```
Contract Address: 0x4fc085056423592277734de8D10328C0875C9dA3
Network: Sepolia (Chain ID: 11155111)
Etherscan: https://sepolia.etherscan.io/address/0x4fc085056423592277734de8D10328C0875C9dA3
```

### Key Functions
- `issueCredential()` - Mint new credential NFT
- `revokeCredential()` - Invalidate a credential
- `getCredentialMetadata()` - Retrieve credential details
- `getStudentCredentials()` - List all credentials for a student
- `authorizeInstitution()` - Grant minting rights (admin only)

## Available Scripts

```bash
npm run dev          # Start development server (port 5173)
npm run build        # Build for production
npm run preview      # Preview production build (port 4173)
npm run lint         # Run ESLint
npm run typecheck    # TypeScript type checking
```

## Project Structure

```
project/
├── contracts/                  # Solidity smart contracts
│   └── AcademicCredentials.sol
├── src/
│   ├── components/            # React components
│   │   ├── AdminPanel.tsx
│   │   ├── InstitutionDashboard.tsx
│   │   ├── StudentWallet.tsx
│   │   ├── VerificationPortal.tsx
│   │   ├── Credential3DShowcase.tsx
│   │   └── dashboard/         # Operations dashboard
│   ├── contracts/             # Contract ABI and address
│   ├── types/                 # TypeScript interfaces
│   ├── utils/                 # Utility functions
│   │   ├── blockchain.ts      # Web3 interactions
│   │   ├── ipfs.ts           # IPFS operations
│   │   ├── supabase.ts       # Database queries
│   │   └── subscriptions.ts  # Payment logic
│   ├── App.tsx               # Main app component
│   └── main.tsx              # Entry point
├── supabase/                  # Database migrations
│   └── migrations/
├── COMMANDS.md               # Detailed command reference
└── package.json              # Dependencies
```

## Features in Detail

### Soulbound Tokens (SBTs)
- Non-transferable NFTs permanently bound to student wallet
- Prevents credential trading or theft
- Immutable on-chain proof of achievement
- ERC-721 compatible with custom transfer restrictions

### 3D Credential Showcase
- Interactive 3D card animations using Framer Motion
- Three view modes: Grid, Stack, Focus
- Mouse-driven rotation and parallax effects
- Holographic security patterns
- Flip animation to reveal detailed metadata

### Share Links & QR Codes
- Time-limited access tokens (1h to 30 days)
- Track verification attempts and access logs
- Revocable at any time
- Password protection (optional)
- Printable QR codes for offline sharing

### Audit Trail
- Complete on-chain event history
- Issued, verified, shared, revoked actions
- Actor addresses and timestamps
- Metadata for each event
- Exportable audit logs

### Operations Dashboard
- Real-time system health monitoring
- Service status (Blockchain RPC, IPFS, Database, Smart Contract)
- Activity feed with recent events
- AI-powered assistant for platform help
- Analytics and metrics visualization

## Security Features

### Row Level Security (RLS)
All database tables enforce strict RLS policies:
- Students can only access their own credentials
- Institutions can only issue to authorized students
- Admins have elevated permissions
- Public verification requires no authentication

### Smart Contract Security
- Owner-only authorization functions
- Reentrancy protection
- Input validation on all functions
- Soulbound transfer restrictions
- Revocation mechanism for compromised credentials

### IPFS Security
- Content-addressed storage (tamper detection)
- Pinned across multiple nodes (availability)
- Hash verification on retrieval
- No private data in IPFS (only public documents)

## Subscription Plans

### Student
- Free forever
- Unlimited credential viewing
- Unlimited share links and QR codes
- Full audit trail access

### Employer/Verifier
- 3 free verifications
- Then subscription required
- Unlimited verifications with plan

### Institution Basic - $49/month
- 100 credentials per month
- Email support
- Basic analytics

### Institution Pro - $199/month
- 500 credentials per month
- Priority support
- API access
- Advanced analytics

### Institution Enterprise - Custom pricing
- Unlimited credentials
- White-label solution
- Bulk minting
- Dedicated support
- Custom integrations

## API Documentation

### Blockchain API (via Ethers.js)
```typescript
// Connect wallet
const address = await connectWallet();

// Issue credential
const { tokenId, txHash } = await issueCredential(
  studentAddress,
  ipfsHash,
  degree,
  institution
);

// Verify credential
const credential = await verifyCredential(tokenId);
```

### Database API (via Supabase)
```typescript
// Save credential record
await saveCredential(tokenId, studentAddress, institution, ...);

// Get student credentials
const credentials = await getCredentialsByStudent(address);

// Create share link
const token = await createShareToken(credentialId, sharedWith, hours);
```

### IPFS API (via Pinata)
```typescript
// Upload document
const ipfsHash = await uploadToIPFS(file);

// Get document URL
const url = getIPFSUrl(ipfsHash);
```

## Troubleshooting

### MetaMask Not Connecting
1. Ensure MetaMask is unlocked
2. Switch to Sepolia Testnet
3. Clear browser cache
4. Check console for errors (F12)

### Transaction Failing
1. Increase gas limit in MetaMask
2. Verify sufficient Sepolia ETH balance
3. Check contract address is correct
4. Ensure institution is authorized

### IPFS Upload Failed
1. Check file size (<10 MB)
2. Verify internet connection
3. Check Pinata API key validity
4. Try different file format (PDF, PNG, JPG)

## Contributing

Contributions are welcome! Please follow these guidelines:
1. Fork the repository
2. Create a feature branch
3. Follow existing code style
4. Add tests for new features
5. Update documentation
6. Submit pull request

## License

This project is proprietary software developed for academic credential management.

## Support

For issues and questions:
- GitHub Issues: <repository-url>/issues
- Email: support@acadchain.com
- Documentation: See COMMANDS.md for detailed usage

## Roadmap

### Phase 1 (Current)
- Basic credential issuance and verification
- 3D showcase and sharing features
- Subscription management
- Operations dashboard

### Phase 2 (Planned)
- Multi-chain support (Polygon, Arbitrum)
- Bulk credential minting
- API for third-party integrations
- Mobile app (React Native)
- Advanced analytics dashboard

### Phase 3 (Future)
- AI-powered fraud detection
- Credential templates marketplace
- International language support
- Integration with university SIS systems
- NFT marketplace for non-academic credentials

## Acknowledgments

- Ethereum Foundation for Sepolia testnet
- Pinata for IPFS infrastructure
- Supabase for database hosting
- OpenZeppelin for secure smart contract libraries
- MetaMask for wallet integration

---

**Built with blockchain technology for a fraud-free academic future.**

**Deploy Status:** Production Ready
**Last Updated:** December 2024
**Version:** 1.0.0
