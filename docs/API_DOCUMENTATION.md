# MegaBank Core Banking API Documentation

## Overview

The MegaBank Core Banking API provides RESTful endpoints for managing banking operations including account management, transactions, and balance inquiries.

**Base URL:** `http://localhost:8080`  
**Version:** 2.3.1  
**Protocol:** HTTP (HTTPS pending certificate renewal)

## Endpoints

### Health Check

**Endpoint:** `GET /health`  
**Description:** Check the health status of the API and database connectivity

**Response:**
```json
{
    "service": "MegaBank Core Banking API",
    "status": "healthy",
    "timestamp": "2024-01-22T19:45:23.123456",
    "version": "2.3.1",
    "database": "connected"
}
```

### Get Account Balance

**Endpoint:** `GET /api/accounts/{account_id}/balance`  
**Description:** Retrieve the current balance for a specific account

**Parameters:**
- `account_id` (path): Account number (e.g., ACC001)

**Response:**
```json
{
    "account_number": "ACC001",
    "customer_name": "John Smith",
    "balance": 15000.00
}
```

### Create Transaction

**Endpoint:** `POST /api/transactions`  
**Description:** Create a new transaction between accounts

**Request Body:**
```json
{
    "from_account": "ACC001",
    "to_account": "ACC002",
    "amount": 500.00
}
```

**Response:**
```json
{
    "transaction_id": 1001,
    "status": "completed"
}
```

### API Status

**Endpoint:** `GET /api/status`  
**Description:** Get current API status and version information

**Response:**
```json
{
    "api": "MegaBank Core Banking API",
    "version": "2.3.1",
    "environment": "production",
    "uptime": "operational"
}
```

## Testing the API

Use curl to test endpoints:

```bash
# Health check
curl http://localhost:8080/health

# Get balance
curl http://localhost:8080/api/accounts/ACC001/balance

# Create transaction
curl -X POST http://localhost:8080/api/transactions \
  -H "Content-Type: application/json" \
  -d '{"from_account":"ACC001","to_account":"ACC002","amount":500.00}'
```

## Error Codes

- `200` - Success
- `201` - Created
- `404` - Not Found
- `500` - Internal Server Error
- `503` - Service Unavailable

## Database Schema

### Accounts Table
- account_number (PK)
- customer_name
- balance
- account_type
- created_date
- last_updated

### Transactions Table
- transaction_id (PK)
- from_account (FK)
- to_account (FK)
- amount
- transaction_date
- status
