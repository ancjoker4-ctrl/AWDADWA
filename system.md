# ZK LEDGER - System Architecture & Workflow Documentation

## Table of Contents
1. [System Architecture Overview](#system-architecture-overview)
2. [Component Architecture](#component-architecture)
3. [System Architecture Workflow](#system-architecture-workflow)
4. [User Workflows](#user-workflows)
5. [Data Flow Diagrams](#data-flow-diagrams)
6. [Security Architecture](#security-architecture)

---

## System Architecture Overview

ZK LEDGER is a blockchain-based academic credential verification platform that combines Ethereum smart contracts, IPFS distributed storage, and Supabase database to create a secure, immutable, and verifiable credential system.

### Core Components

```
┌─────────────────────────────────────────────────────────────────────┐
│                         SYSTEM ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌─────────────┐      ┌──────────────┐      ┌─────────────┐        │
│  │   Frontend  │◄────►│   Backend    │◄────►│  Blockchain │        │
│  │   (React)   │      │  (Supabase)  │      │  (Ethereum) │        │
│  └─────────────┘      └──────────────┘      └─────────────┘        │
│         │                     │                     │                │
│         │                     │                     │                │
│         └─────────────────────┼─────────────────────┘                │
│                               │                                      │
│                        ┌──────▼──────┐                              │
│                        │    IPFS     │                              │
│                        │  (Pinata)   │                              │
│                        └─────────────┘                              │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Component Architecture

### 1. Frontend Layer (React + TypeScript)

```
┌────────────────────────────────────────────────────────────────┐
│                      FRONTEND ARCHITECTURE                      │
├────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌──────────┐ │
│  │   Landing  │  │   Login    │  │   Admin    │  │ Student  │ │
│  │    Page    │  │    Page    │  │   Panel    │  │  Wallet  │ │
│  └────────────┘  └────────────┘  └────────────┘  └──────────┘ │
│                                                                  │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌──────────┐ │
│  │Institution │  │Verification│  │ Operations │  │ Pricing  │ │
│  │ Dashboard  │  │   Portal   │  │ Dashboard  │  │  Modal   │ │
│  └────────────┘  └────────────┘  └────────────┘  └──────────┘ │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              UTILITY MODULES                              │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │ blockchain.ts │ ipfs.ts │ supabase.ts │ subscriptions.ts │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
└────────────────────────────────────────────────────────────────┘
```

### 2. Blockchain Layer (Ethereum Sepolia)

```
┌──────────────────────────────────────────────────────────┐
│            SMART CONTRACT ARCHITECTURE                    │
├──────────────────────────────────────────────────────────┤
│                                                            │
│  AcademicCredentials Contract (ERC-721 Soulbound)        │
│                                                            │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Core Functions:                                   │  │
│  │  • authorizeInstitution(address)                   │  │
│  │  • revokeInstitutionAuth(address)                  │  │
│  │  • issueCredential(student, ipfsHash, ...)        │  │
│  │  • revokeCredential(tokenId)                       │  │
│  │  • getCredentialMetadata(tokenId)                  │  │
│  │  • getStudentCredentials(address)                  │  │
│  └────────────────────────────────────────────────────┘  │
│                                                            │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Storage:                                          │  │
│  │  • mapping(tokenId => Credential)                  │  │
│  │  • mapping(address => authorized)                  │  │
│  │  • mapping(student => tokenIds[])                  │  │
│  └────────────────────────────────────────────────────┘  │
│                                                            │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Events:                                           │  │
│  │  • CredentialIssued(tokenId, student, ...)        │  │
│  │  • CredentialRevoked(tokenId)                      │  │
│  │  • InstitutionAuthorized(address)                  │  │
│  │  • InstitutionRevoked(address)                     │  │
│  └────────────────────────────────────────────────────┘  │
│                                                            │
└──────────────────────────────────────────────────────────┘
```

### 3. Storage Layer (IPFS + Supabase)

```
┌─────────────────────────────────────────────────────────────┐
│                    STORAGE ARCHITECTURE                      │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────┐       ┌───────────────────────┐   │
│  │   IPFS (Pinata)     │       │   Supabase Database   │   │
│  ├─────────────────────┤       ├───────────────────────┤   │
│  │                     │       │                       │   │
│  │ • Document Files    │       │ • credentials         │   │
│  │   (PDF, PNG, JPG)   │       │ • credential_shares   │   │
│  │                     │       │ • audit_logs          │   │
│  │ • Metadata          │       │ • student_profiles    │   │
│  │                     │       │ • institution_auth    │   │
│  │ • CIDv1 Hashing     │       │ • pricing_plans       │   │
│  │                     │       │ • user_subscriptions  │   │
│  │ • Pinning Service   │       │ • payment_trans       │   │
│  │                     │       │ • promo_codes         │   │
│  │                     │       │                       │   │
│  └─────────────────────┘       └───────────────────────┘   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## System Architecture Workflow

### End-to-End Credential Issuance Flow

```
┌──────────────────────────────────────────────────────────────────────────┐
│                    CREDENTIAL ISSUANCE WORKFLOW                           │
└──────────────────────────────────────────────────────────────────────────┘

Institution                Frontend              IPFS          Blockchain      Supabase
    │                         │                    │                │             │
    │ 1. Fill Form            │                    │                │             │
    │ (student, degree, doc)  │                    │                │             │
    ├────────────────────────>│                    │                │             │
    │                         │                    │                │             │
    │                         │ 2. Upload Document │                │             │
    │                         │───────────────────>│                │             │
    │                         │                    │                │             │
    │                         │ 3. Return IPFS Hash│                │             │
    │                         │<───────────────────│                │             │
    │                         │                    │                │             │
    │                         │ 4. Call issueCredential(student, hash, degree, institution)
    │                         │────────────────────────────────────>│             │
    │                         │                    │                │             │
    │                         │                    │ 5. Mint NFT    │             │
    │                         │                    │   (Soulbound)  │             │
    │                         │                    │   Emit Event   │             │
    │                         │                    │                │             │
    │                         │ 6. Transaction Receipt (tokenId)    │             │
    │                         │<────────────────────────────────────│             │
    │                         │                    │                │             │
    │                         │ 7. Save to Database (credentials table)           │
    │                         │──────────────────────────────────────────────────>│
    │                         │                    │                │             │
    │                         │ 8. Log Audit Event (action: 'issued')             │
    │                         │──────────────────────────────────────────────────>│
    │                         │                    │                │             │
    │ 9. Success Notification │                    │                │             │
    │<────────────────────────│                    │                │             │
    │    (Token ID)           │                    │                │             │
    │                         │                    │                │             │
```

### Credential Verification Flow

```
┌──────────────────────────────────────────────────────────────────────────┐
│                    CREDENTIAL VERIFICATION WORKFLOW                       │
└──────────────────────────────────────────────────────────────────────────┘

Verifier                Frontend              Blockchain      IPFS          Supabase
    │                      │                       │            │               │
    │ 1. Enter Token ID    │                       │            │               │
    │  or Scan QR Code     │                       │            │               │
    ├─────────────────────>│                       │            │               │
    │                      │                       │            │               │
    │                      │ 2. Query Smart Contract            │               │
    │                      │  getCredentialMetadata(tokenId)    │               │
    │                      │──────────────────────>│            │               │
    │                      │                       │            │               │
    │                      │ 3. Return Metadata    │            │               │
    │                      │  (hash, degree, inst, │            │               │
    │                      │   student, date, revoked)          │               │
    │                      │<──────────────────────│            │               │
    │                      │                       │            │               │
    │                      │ 4. Fetch Document     │            │               │
    │                      │  from IPFS (hash)     │            │               │
    │                      │────────────────────────────────────>│               │
    │                      │                       │            │               │
    │                      │ 5. Return Document    │            │               │
    │                      │<────────────────────────────────────│               │
    │                      │                       │            │               │
    │                      │ 6. Log Access (audit_logs, action: 'verified')     │
    │                      │────────────────────────────────────────────────────>│
    │                      │                       │            │               │
    │ 7. Display Results   │                       │            │               │
    │  - Credential Details│                       │            │               │
    │  - Verification Badge│                       │            │               │
    │  - Document Link     │                       │            │               │
    │<─────────────────────│                       │            │               │
    │                      │                       │            │               │
```

### Share Link Generation Flow

```
┌──────────────────────────────────────────────────────────────────────────┐
│                    SHARE LINK GENERATION WORKFLOW                         │
└──────────────────────────────────────────────────────────────────────────┘

Student                 Frontend                          Supabase
    │                      │                                  │
    │ 1. Select Credential │                                  │
    │    Click "Share"     │                                  │
    ├─────────────────────>│                                  │
    │                      │                                  │
    │ 2. Set Parameters    │                                  │
    │    - Recipient Name  │                                  │
    │    - Expiration Time │                                  │
    ├─────────────────────>│                                  │
    │                      │                                  │
    │                      │ 3. Generate Share Token          │
    │                      │    (share_<timestamp>_<random>)  │
    │                      │                                  │
    │                      │ 4. Insert into credential_shares │
    │                      │    (credential_id, share_token,  │
    │                      │     shared_with, expires_at)     │
    │                      │─────────────────────────────────>│
    │                      │                                  │
    │                      │ 5. Log Audit Event               │
    │                      │    (action: 'shared')            │
    │                      │─────────────────────────────────>│
    │                      │                                  │
    │ 6. Return Share URL  │                                  │
    │    (domain?verify=   │                                  │
    │     &token=xxx)      │                                  │
    │<─────────────────────│                                  │
    │                      │                                  │
    │ 7. Copy/Send Link    │                                  │
    │                      │                                  │
```

---

## User Workflows

### 1. Admin Workflow

```
┌────────────────────────────────────────────────────────────────┐
│                      ADMIN USER WORKFLOW                        │
└────────────────────────────────────────────────────────────────┘

START
  │
  ▼
┌───────────────┐
│ Connect Wallet│
│  (MetaMask)   │
└───────┬───────┘
        │
        ▼
┌───────────────────┐
│ Login as Admin    │
│ (admin@acadchain) │
└───────┬───────────┘
        │
        ▼
┌───────────────────────────────────────────┐
│         Admin Panel Dashboard              │
├───────────────────────────────────────────┤
│                                            │
│  ┌─────────────────────────────────────┐  │
│  │  View Authorization Requests        │  │
│  │  - Pending Institutions             │  │
│  │  - Institution Details              │  │
│  │  - Wallet Address                   │  │
│  └─────────────┬───────────────────────┘  │
│                │                           │
│                ▼                           │
│  ┌─────────────────────────────────────┐  │
│  │  Review Institution                 │  │
│  │  - Check Documentation              │  │
│  │  - Verify Credentials               │  │
│  │  - Validate Wallet                  │  │
│  └─────────────┬───────────────────────┘  │
│                │                           │
│         ┌──────┴──────┐                   │
│         ▼             ▼                    │
│  ┌──────────┐  ┌──────────┐              │
│  │ APPROVE  │  │  REJECT  │              │
│  └────┬─────┘  └────┬─────┘              │
│       │             │                     │
│       │             ▼                     │
│       │    ┌──────────────────┐          │
│       │    │ Update DB Status │          │
│       │    │ (status: rejected)│         │
│       │    │ Send Notification │         │
│       │    └──────────────────┘          │
│       │                                   │
│       ▼                                   │
│  ┌──────────────────────────┐            │
│  │ Call Smart Contract      │            │
│  │ authorizeInstitution()   │            │
│  └────┬─────────────────────┘            │
│       │                                   │
│       ▼                                   │
│  ┌──────────────────────────┐            │
│  │ Update Database          │            │
│  │ (status: approved)       │            │
│  │ Send Notification        │            │
│  └────┬─────────────────────┘            │
│       │                                   │
└───────┼───────────────────────────────────┘
        │
        ▼
┌──────────────────┐
│ Monitor Platform │
│ - View Audit Logs│
│ - System Health  │
│ - Operations     │
└──────────────────┘
        │
        ▼
       END
```

### 2. Institution Workflow

```
┌────────────────────────────────────────────────────────────────┐
│                  INSTITUTION USER WORKFLOW                      │
└────────────────────────────────────────────────────────────────┘

START
  │
  ▼
┌───────────────┐
│ Connect Wallet│
└───────┬───────┘
        │
        ▼
┌──────────────────────┐      YES    ┌──────────────────┐
│ Authorized?          │────────────>│ Login to Portal  │
│ (Check Contract)     │             └────────┬─────────┘
└─────────┬────────────┘                      │
          │ NO                                │
          ▼                                   │
┌──────────────────────┐                      │
│ Request Authorization│                      │
│ - Fill Form          │                      │
│ - Submit Request     │                      │
│ - Wait for Approval  │                      │
└─────────┬────────────┘                      │
          │                                   │
          │ (APPROVED)                        │
          │                                   │
          └───────────────────────────────────┤
                                              │
                                              ▼
                            ┌──────────────────────────────┐
                            │ Check Subscription           │
                            │ (Basic/Pro/Enterprise)       │
                            └────┬─────────────────┬───────┘
                                 │ NO              │ YES
                                 │                 │
                                 ▼                 ▼
                        ┌─────────────────┐  ┌──────────────────────┐
                        │ View Pricing    │  │ Institution Dashboard│
                        │ Subscribe Plan  │  ├──────────────────────┤
                        │ (Use TRINETRA)  │  │ • Issue Credentials  │
                        └────┬────────────┘  │ • View Students      │
                             │               │ • Monitor Stats      │
                             │               └──────┬───────────────┘
                             └───────────────────────┘
                                              │
                                              ▼
                            ┌──────────────────────────────┐
                            │ Issue Credential             │
                            ├──────────────────────────────┤
                            │ 1. Enter Student Address     │
                            │ 2. Fill Degree Details       │
                            │ 3. Upload Document (PDF)     │
                            │ 4. Review Information        │
                            └────┬─────────────────────────┘
                                 │
                                 ▼
                            ┌──────────────────────────────┐
                            │ Confirm Transaction          │
                            │ - MetaMask Popup             │
                            │ - Gas Fee Approval           │
                            └────┬─────────────────────────┘
                                 │
                                 ▼
                            ┌──────────────────────────────┐
                            │ Wait for Confirmation        │
                            │ - IPFS Upload (~5-10s)       │
                            │ - Blockchain Mint (~5s)      │
                            └────┬─────────────────────────┘
                                 │
                                 ▼
                            ┌──────────────────────────────┐
                            │ Success!                     │
                            │ - Display Token ID           │
                            │ - Update Stats               │
                            │ - Send to Student            │
                            └──────────────────────────────┘
                                 │
                                 ▼
                                END
```

### 3. Student Workflow

```
┌────────────────────────────────────────────────────────────────┐
│                    STUDENT USER WORKFLOW                        │
└────────────────────────────────────────────────────────────────┘

START
  │
  ▼
┌───────────────┐
│ Connect Wallet│
│  (MetaMask)   │
└───────┬───────┘
        │
        ▼
┌──────────────────────┐
│ Login/Sign Up        │
│ - Email & Name       │
│ - Select Institution │
└───────┬──────────────┘
        │
        ▼
┌─────────────────────────────────────────────────┐
│           Student Wallet Dashboard               │
├─────────────────────────────────────────────────┤
│                                                  │
│  ┌────────────────────────────────────────┐    │
│  │ View My Credentials                    │    │
│  │ - Query Blockchain (by wallet address)│    │
│  │ - Display All Credentials              │    │
│  └──────────┬─────────────────────────────┘    │
│             │                                    │
│             ▼                                    │
│  ┌────────────────────────────────────────┐    │
│  │ Select View Mode                       │    │
│  ├────────────┬───────────────────────────┤    │
│  │ Grid View  │ 3D Showcase (Interactive) │    │
│  └────────────┴───────────────────────────┘    │
│             │                                    │
│             ▼                                    │
│  ┌────────────────────────────────────────┐    │
│  │ Select Credential                      │    │
│  └──────────┬─────────────────────────────┘    │
│             │                                    │
│      ┌──────┴──────┬──────────┬──────────┐     │
│      ▼             ▼          ▼          ▼      │
│  ┌────────┐  ┌────────┐  ┌───────┐  ┌───────┐ │
│  │  View  │  │ Share  │  │  QR   │  │History│ │
│  │Document│  │  Link  │  │ Code  │  │ Audit │ │
│  └────────┘  └───┬────┘  └───────┘  └───────┘ │
│                  │                              │
└──────────────────┼──────────────────────────────┘
                   │
                   ▼
        ┌────────────────────────┐
        │ Generate Share Link    │
        ├────────────────────────┤
        │ 1. Enter Recipient     │
        │ 2. Set Expiration      │
        │    - 1 hour            │
        │    - 24 hours          │
        │    - 7 days            │
        │    - Custom            │
        └────┬───────────────────┘
             │
             ▼
        ┌────────────────────────┐
        │ Create Share Token     │
        │ - Generate URL         │
        │ - Save to Database     │
        │ - Log Audit Event      │
        └────┬───────────────────┘
             │
             ▼
        ┌────────────────────────┐
        │ Copy Link & Share      │
        │ - Email                │
        │ - Social Media         │
        │ - Print QR Code        │
        └────┬───────────────────┘
             │
             ▼
        ┌────────────────────────┐
        │ Track Access           │
        │ - View who accessed    │
        │ - When accessed        │
        │ - Access count         │
        └────────────────────────┘
             │
             ▼
            END
```

### 4. Verifier/Employer Workflow

```
┌────────────────────────────────────────────────────────────────┐
│                VERIFIER/EMPLOYER USER WORKFLOW                  │
└────────────────────────────────────────────────────────────────┘

START
  │
  ▼
┌─────────────────────────┐
│ Access Verification     │
│ Portal (Public)         │
│ - No wallet required    │
│ - No login required     │
└───────┬─────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│ Choose Verification Method           │
├──────────────┬───────────────────────┤
│ Enter Token  │ Scan QR Code          │
│      ID      │ (from student)        │
└──────┬───────┴────────┬──────────────┘
       │                │
       └────────┬───────┘
                │
                ▼
        ┌───────────────────┐
        │ Query Blockchain  │
        │ - Token ID lookup │
        │ - Get metadata    │
        └────┬──────────────┘
             │
      ┌──────┴──────┐
      │ Valid?      │
      └─┬─────────┬─┘
   YES  │         │  NO
        │         │
        ▼         ▼
┌───────────┐  ┌──────────────┐
│ Credential│  │ Error        │
│   Found   │  │ - Invalid ID │
└─────┬─────┘  │ - Not Found  │
      │        └──────────────┘
      │             │
      │             ▼
      │            END
      │
      ▼
┌─────────────────────────────────────┐
│ Display Credential Details          │
├─────────────────────────────────────┤
│ • Student Address                   │
│ • Degree/Program                    │
│ • Institution Name                  │
│ • Issue Date                        │
│ • Verification Status               │
│   ┌───────────────────────────┐    │
│   │ ✓ VERIFIED                │    │
│   │   Active on Blockchain    │    │
│   └───────────────────────────┘    │
│                  OR                 │
│   ┌───────────────────────────┐    │
│   │ ✗ REVOKED                 │    │
│   │   Credential Invalid      │    │
│   └───────────────────────────┘    │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│ View Document                       │
│ - Click IPFS link                   │
│ - Download PDF/PNG                  │
│ - Verify hash matches               │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│ Blockchain Proof                    │
│ - Token ID                          │
│ - IPFS Hash                         │
│ - Transaction Hash                  │
│ - Contract Address                  │
│ - Etherscan Link                    │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│ Decision                            │
├──────────────┬──────────────────────┤
│ Accept       │ Further Investigation│
│ Application  │ Contact Institution  │
└──────────────┴──────────────────────┘
           │
           ▼
          END
```

---

## Data Flow Diagrams

### 1. Credential Creation Data Flow

```
┌────────────────────────────────────────────────────────────────┐
│              CREDENTIAL CREATION DATA FLOW                      │
└────────────────────────────────────────────────────────────────┘

Input Data:
┌──────────────────────────────────────┐
│ • Student Wallet Address             │
│ • Student Full Name                  │
│ • Degree Title                       │
│ • Institution Name                   │
│ • Graduation Year                    │
│ • Document File (PDF/PNG/JPG)        │
└──────────────┬───────────────────────┘
               │
               ▼
┌──────────────────────────────────────┐
│ STEP 1: Document Upload to IPFS     │
├──────────────────────────────────────┤
│ Frontend → Pinata API                │
│ • FormData with file                 │
│ • Metadata (name, type, timestamp)   │
│ • Returns: CIDv1 hash                │
└──────────────┬───────────────────────┘
               │
               ▼ (ipfsHash)
               │
┌──────────────────────────────────────┐
│ STEP 2: Blockchain Minting          │
├──────────────────────────────────────┤
│ Smart Contract Call:                 │
│ issueCredential(                     │
│   studentAddress,                    │
│   ipfsHash,                          │
│   degree,                            │
│   institution                        │
│ )                                    │
│                                      │
│ On-Chain Storage:                    │
│ • tokenId (auto-increment)           │
│ • ipfsHash                           │
│ • degree                             │
│ • institution                        │
│ • student address                    │
│ • issue timestamp                    │
│ • revoked (false)                    │
└──────────────┬───────────────────────┘
               │
               ▼ (tokenId, txHash)
               │
┌──────────────────────────────────────┐
│ STEP 3: Database Record Creation    │
├──────────────────────────────────────┤
│ Supabase Insert:                     │
│ credentials {                        │
│   token_id,                          │
│   student_address,                   │
│   institution_name,                  │
│   institution_address,               │
│   degree,                            │
│   ipfs_hash,                         │
│   issue_date,                        │
│   revoked: false                     │
│ }                                    │
└──────────────┬───────────────────────┘
               │
               ▼ (credentialId)
               │
┌──────────────────────────────────────┐
│ STEP 4: Audit Log Creation          │
├──────────────────────────────────────┤
│ audit_logs {                         │
│   credential_id,                     │
│   action: 'issued',                  │
│   actor_address: institution,        │
│   metadata: {                        │
│     tokenId,                         │
│     degree,                          │
│     institutionName                  │
│   },                                 │
│   created_at: now()                  │
│ }                                    │
└──────────────┬───────────────────────┘
               │
               ▼
┌──────────────────────────────────────┐
│ OUTPUT: Success Response             │
├──────────────────────────────────────┤
│ {                                    │
│   tokenId: "123",                    │
│   txHash: "0xabc...",                │
│   status: "success",                 │
│   message: "Credential issued"       │
│ }                                    │
└──────────────────────────────────────┘
```

### 2. Verification Data Flow

```
┌────────────────────────────────────────────────────────────────┐
│              CREDENTIAL VERIFICATION DATA FLOW                  │
└────────────────────────────────────────────────────────────────┘

Input: Token ID or Share Token
         │
         ▼
┌────────────────────────────┐
│ Is Share Token?            │
└─┬──────────────────────┬───┘
  │ NO                   │ YES
  │ (Direct Token ID)    │
  │                      ▼
  │            ┌──────────────────────────┐
  │            │ Query credential_shares  │
  │            │ WHERE share_token = ?    │
  │            │ AND expires_at > now()   │
  │            └────────┬─────────────────┘
  │                     │
  │                     ▼
  │            ┌──────────────────────────┐
  │            │ Get credential_id        │
  │            │ Increment access_count   │
  │            └────────┬─────────────────┘
  │                     │
  └─────────────┬───────┘
                │
                ▼ (tokenId)
┌─────────────────────────────────────┐
│ STEP 1: Query Smart Contract       │
├─────────────────────────────────────┤
│ getCredentialMetadata(tokenId)      │
│                                     │
│ Returns:                            │
│ • ipfsHash                          │
│ • degree                            │
│ • institution                       │
│ • student address                   │
│ • issue timestamp                   │
│ • revoked (boolean)                 │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ STEP 2: Fetch Document from IPFS   │
├─────────────────────────────────────┤
│ GET gateway.pinata.cloud/ipfs/{hash}│
│                                     │
│ Returns: PDF/PNG/JPG file           │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ STEP 3: Query Database (Optional)  │
├─────────────────────────────────────┤
│ Get additional info:                │
│ • Institution contact               │
│ • Student profile                   │
│ • Audit history                     │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ STEP 4: Log Verification            │
├─────────────────────────────────────┤
│ audit_logs {                        │
│   credential_id,                    │
│   action: 'verified',               │
│   actor_address: verifier,          │
│   metadata: { shareToken/tokenId }, │
│   created_at: now()                 │
│ }                                   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ OUTPUT: Verification Result         │
├─────────────────────────────────────┤
│ {                                   │
│   valid: true/false,                │
│   revoked: true/false,              │
│   credential: {                     │
│     tokenId, degree, institution,   │
│     student, issueDate              │
│   },                                │
│   documentUrl: "ipfs://...",        │
│   blockchainProof: {                │
│     contractAddress,                │
│     tokenId,                        │
│     txHash                          │
│   }                                 │
│ }                                   │
└─────────────────────────────────────┘
```

---

## Security Architecture

### 1. Security Layers

```
┌────────────────────────────────────────────────────────────────┐
│                     SECURITY ARCHITECTURE                       │
└────────────────────────────────────────────────────────────────┘

Layer 1: Frontend Security
├─ HTTPS Encryption
├─ Content Security Policy (CSP)
├─ XSS Protection
├─ Input Validation
└─ Client-Side Wallet Connection (MetaMask)

Layer 2: Blockchain Security
├─ Soulbound Token (Non-Transferable)
│  └─ Custom _update() override prevents transfers
├─ Access Control
│  ├─ Owner-only functions (admin)
│  ├─ Authorized institutions mapping
│  └─ Function modifiers (onlyOwner, onlyAuthorized)
├─ Immutable Records
│  └─ Once minted, metadata cannot be changed
└─ Event Logging
   └─ All actions emit events for transparency

Layer 3: IPFS Security
├─ Content Addressing (CID)
│  └─ Hash-based verification
├─ Pinning Service (Pinata)
│  └─ Redundancy across nodes
├─ Metadata Encryption (optional)
└─ Gateway Access Control

Layer 4: Database Security (Supabase)
├─ Row Level Security (RLS)
│  ├─ Students: Can only read own credentials
│  ├─ Institutions: Can only read own issued credentials
│  └─ Public: No direct access without share token
├─ Data Encryption
│  ├─ At-rest encryption
│  └─ In-transit encryption (TLS)
├─ API Key Protection
│  └─ Environment variables only
└─ Audit Logging
   └─ All CRUD operations logged

Layer 5: Application Security
├─ Authentication
│  ├─ Wallet-based (signature verification)
│  └─ Email/password for profiles
├─ Authorization
│  ├─ Role-based access control (RBAC)
│  └─ Subscription-based features
├─ Rate Limiting
│  └─ Free tier: 3 verifications/session
└─ Session Management
   └─ Secure token handling
```

### 2. Data Privacy Flow

```
┌────────────────────────────────────────────────────────────────┐
│                    DATA PRIVACY ARCHITECTURE                    │
└────────────────────────────────────────────────────────────────┘

PERSONAL DATA CATEGORIES:
┌──────────────────────────────────────────────────────────────┐
│ On-Chain (Public):                                           │
│ • Wallet addresses (pseudonymous)                           │
│ • Token IDs                                                 │
│ • IPFS hashes                                               │
│ • Timestamps                                                │
│ • Institution names                                         │
│ • Degree titles                                             │
├──────────────────────────────────────────────────────────────┤
│ Off-Chain (Database, RLS Protected):                        │
│ • Student full names                                        │
│ • Email addresses                                           │
│ • Institution contact info                                  │
│ • Share tokens (temporary)                                  │
│ • Audit logs (access tracking)                              │
├──────────────────────────────────────────────────────────────┤
│ IPFS (Content-Addressed, Optionally Encrypted):             │
│ • PDF documents                                             │
│ • Images (PNG/JPG)                                          │
│ • Metadata (filename, upload date)                          │
└──────────────────────────────────────────────────────────────┘

PRIVACY CONTROLS:
┌──────────────────────────────────────────────────────────────┐
│ 1. Consent & Control                                         │
│    • Students control who sees credentials (share links)    │
│    • Time-limited access (expiration)                       │
│    • Revocation support                                     │
│                                                              │
│ 2. Data Minimization                                        │
│    • Only essential data on blockchain                      │
│    • PII kept off-chain with RLS                            │
│    • No KYC required for students                           │
│                                                              │
│ 3. Right to be Forgotten (GDPR)                             │
│    • Database records can be deleted                        │
│    • IPFS documents can be unpinned                         │
│    • Blockchain records marked as revoked                   │
│    • Note: On-chain data is immutable (revoked flag only)   │
│                                                              │
│ 4. Access Logging & Transparency                            │
│    • All verifications logged                               │
│    • Students can view access history                       │
│    • Audit trail for compliance                             │
└──────────────────────────────────────────────────────────────┘
```

### 3. Threat Model & Mitigations

```
┌────────────────────────────────────────────────────────────────┐
│                  THREAT MODEL & MITIGATIONS                     │
└────────────────────────────────────────────────────────────────┘

THREAT 1: Fake Credentials
├─ Attack: Unauthorized user mints fake credential
└─ Mitigation:
   ├─ Only authorized institutions can mint
   ├─ Admin approval required for authorization
   ├─ On-chain whitelist (authorizedInstitutions mapping)
   └─ Blockchain provides transparent audit trail

THREAT 2: Credential Theft/Transfer
├─ Attack: Attacker steals student's credential NFT
└─ Mitigation:
   ├─ Soulbound token (non-transferable)
   ├─ Transfer functions disabled
   └─ Wallet compromise doesn't allow transfer

THREAT 3: Document Tampering
├─ Attack: Modify credential document after issuance
└─ Mitigation:
   ├─ IPFS content addressing (hash verification)
   ├─ Hash stored on blockchain (immutable)
   └─ Any change creates new hash (detectable)

THREAT 4: Share Link Abuse
├─ Attack: Share link leaked or reused maliciously
└─ Mitigation:
   ├─ Time-limited expiration
   ├─ One-time use option
   ├─ Access logging (audit trail)
   └─ Student can revoke link

THREAT 5: Phishing/Social Engineering
├─ Attack: Attacker tricks user into revealing wallet keys
└─ Mitigation:
   ├─ MetaMask warnings for suspicious sites
   ├─ Never request private keys
   ├─ Transaction review before signing
   └─ User education (warning messages)

THREAT 6: Database Breach
├─ Attack: Attacker gains access to Supabase database
└─ Mitigation:
   ├─ Row Level Security (RLS) enforced
   ├─ Encryption at rest and in transit
   ├─ API keys in environment variables
   ├─ No sensitive data without RLS
   └─ Regular security audits

THREAT 7: IPFS Node Failure
├─ Attack: IPFS gateway goes down, documents inaccessible
└─ Mitigation:
   ├─ Pinata pinning service (redundancy)
   ├─ Multiple gateway options
   ├─ Backup on platform servers
   └─ Students can re-upload with same hash

THREAT 8: Smart Contract Vulnerabilities
├─ Attack: Exploit in contract code
└─ Mitigation:
   ├─ OpenZeppelin contracts (battle-tested)
   ├─ Function access controls (modifiers)
   ├─ Event logging for transparency
   ├─ No external calls to untrusted contracts
   └─ Code audit before mainnet deployment
```

---

## Performance Metrics

```
┌────────────────────────────────────────────────────────────────┐
│                    PERFORMANCE BENCHMARKS                       │
└────────────────────────────────────────────────────────────────┘

OPERATION                          AVG TIME    MAX TIME    COST
────────────────────────────────────────────────────────────────
Credential Issuance (End-to-End)    15s         30s       $0.50
├─ IPFS Upload                      5-10s       15s       Free
├─ Blockchain Transaction           5s          15s       $0.50
└─ Database Insert                  <1s         2s        Free

Credential Verification             2s          5s        Free
├─ Blockchain Query                 1s          3s        Free
├─ IPFS Fetch                       1s          2s        Free
└─ Database Query                   <1s         1s        Free

Share Link Generation               <1s         2s        Free
└─ Database Insert + Token Gen      <1s         2s        Free

Student Wallet Load (10 creds)      3s          8s        Free
├─ Blockchain Batch Query           2s          5s        Free
├─ Database Batch Query             1s          3s        Free

Admin Dashboard Load                2s          5s        Free
└─ Database Analytics Query         2s          5s        Free

────────────────────────────────────────────────────────────────
GAS COSTS (Sepolia Testnet - Free, Mainnet estimates):
────────────────────────────────────────────────────────────────
authorizeInstitution()              ~50,000 gas    $0.10
issueCredential()                   ~200,000 gas   $0.50
revokeCredential()                  ~50,000 gas    $0.10
getCredentialMetadata() [Read]      0 gas          Free
────────────────────────────────────────────────────────────────
```

---

## Scalability Considerations

```
┌────────────────────────────────────────────────────────────────┐
│                    SCALABILITY ARCHITECTURE                     │
└────────────────────────────────────────────────────────────────┘

CURRENT CAPACITY:
├─ Blockchain (Ethereum Sepolia):
│  ├─ Block time: ~12 seconds
│  ├─ Credentials/block: 5-10 (gas limit dependent)
│  └─ Theoretical max: ~25,000 credentials/day
│
├─ IPFS (Pinata):
│  ├─ Upload rate: 100+ files/minute
│  ├─ Storage: Unlimited (paid per GB)
│  └─ Gateway: 99.9% uptime SLA
│
└─ Supabase:
   ├─ Database: PostgreSQL 15
   ├─ Connections: 100+ concurrent
   ├─ Storage: 8GB free tier, unlimited paid
   └─ API: 50,000 requests/month free tier

FUTURE SCALING STRATEGIES:
├─ Layer 2 Solutions
│  ├─ Move to Polygon/Arbitrum for lower gas fees
│  ├─ Batch transactions (10-100 credentials/tx)
│  └─ State channels for high-frequency operations
│
├─ IPFS Clustering
│  ├─ Private IPFS cluster for institutions
│  ├─ Regional gateways for low latency
│  └─ CDN integration (Cloudflare IPFS gateway)
│
├─ Database Sharding
│  ├─ Shard by institution (multi-tenant)
│  ├─ Read replicas for verification portal
│  └─ Caching layer (Redis) for hot data
│
└─ Microservices Architecture
   ├─ Separate services for issuing, verifying, sharing
   ├─ API Gateway for load balancing
   └─ Message queue for async processing (RabbitMQ)
```

---

## Conclusion

This system architecture provides:
- High security through blockchain immutability and RLS
- Decentralization via IPFS for document storage
- Scalability through modular design
- Privacy through soulbound tokens and access controls
- Transparency via public verification and audit logs
- User-friendly workflows for all stakeholder types

The architecture is designed to be production-ready while maintaining flexibility for future enhancements and scaling requirements.

---

**Document Version:** 1.0
**Last Updated:** 2025-01-25
**Maintained By:** ZK LEDGER Development Team
