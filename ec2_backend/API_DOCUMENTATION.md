# Smart Insulin App API Documentation

Base URL: `http://18.208.146.17:8080`

## Authentication

All API endpoints (except `/health`) require Firebase authentication. You must include a valid Firebase ID token in the Authorization header of your requests.

### Authentication Format
```
Authorization: Bearer YOUR_FIREBASE_ID_TOKEN
```

### Obtaining a Firebase ID Token

You can obtain a Firebase ID token by using the Firebase Authentication SDK in your client application, or for testing purposes, you can use the Firebase REST API:

```bash
curl 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=<firebase-ley>' \
  -H 'Content-Type: application/json' \
  --data-binary '{"email":"<email>","password":"<password>","returnSecureToken":true}'
```

## Health Check Endpoint

### Check API Health
- **Method**: GET
- **Endpoint**: `/health`
- **Authentication**: Not required
- **Response**:
```json
{
  "status": "ok",
  "timestamp": "ISO timestamp"
}
```

## User Endpoints

### Create/Update User Profile
- **Method**: POST
- **Endpoint**: `/api/users/profile`
- **Authentication**: Required
- **Body**:
```json
{
  "username": "string",
  "email": "string"
}
```
- **Response**:
```json
{
  "message": "User profile created/updated successfully"
}
```

### Get User Profile
- **Method**: GET
- **Endpoint**: `/api/users/profile`
- **Authentication**: Required
- **Response**:
```json
{
  "firebase_uid": "string",
  "username": "string",
  "email": "string",
  "created_at": "timestamp"
}
```

## Insulin Records Endpoints

### Get All Insulin Records
- **Method**: GET
- **Endpoint**: `/api/insulin`
- **Authentication**: Required
- **Response**:
```json
[
  {
    "record_id": "number",
    "firebase_uid": "string",
    "insulin_units": "number",
    "blood_glucose_level": "number",
    "timestamp": "timestamp",
    "notes": "string"
  }
]
```

### Get Specific Insulin Record
- **Method**: GET
- **Endpoint**: `/api/insulin/:recordId`
- **Authentication**: Required
- **Response**:
```json
{
  "record_id": "number",
  "firebase_uid": "string",
  "insulin_units": "number",
  "blood_glucose_level": "number",
  "timestamp": "timestamp",
  "notes": "string"
}
```

### Add Insulin Record
- **Method**: POST
- **Endpoint**: `/api/insulin`
- **Authentication**: Required
- **Body**:
```json
{
  "insulin_units": "number",
  "blood_glucose_level": "number",
  "notes": "string"
}
```
- **Response**:
```json
{
  "id": "number"
}
```

### Update Insulin Record
- **Method**: PUT
- **Endpoint**: `/api/insulin/:recordId`
- **Authentication**: Required
- **Body**:
```json
{
  "insulin_units": "number",
  "blood_glucose_level": "number",
  "notes": "string"
}
```
- **Response**:
```json
{
  "success": true
}
```

### Delete Insulin Record
- **Method**: DELETE
- **Endpoint**: `/api/insulin/:recordId`
- **Authentication**: Required
- **Response**:
```json
{
  "success": true
}
```

## Meal Records Endpoints

### Get All Meal Records
- **Method**: GET
- **Endpoint**: `/api/meals`
- **Authentication**: Required
- **Response**:
```json
[
  {
    "meal_id": "number",
    "firebase_uid": "string",
    "meal_name": "string",
    "carbohydrates": "number",
    "timestamp": "timestamp"
  }
]
```

### Get Specific Meal Record
- **Method**: GET
- **Endpoint**: `/api/meals/:mealId`
- **Authentication**: Required
- **Response**:
```json
{
  "meal_id": "number",
  "firebase_uid": "string",
  "meal_name": "string",
  "carbohydrates": "number",
  "timestamp": "timestamp"
}
```

### Add Meal Record
- **Method**: POST
- **Endpoint**: `/api/meals`
- **Authentication**: Required
- **Body**:
```json
{
  "meal_name": "string",
  "carbohydrates": "number"
}
```
- **Response**:
```json
{
  "id": "number"
}
```

### Update Meal Record
- **Method**: PUT
- **Endpoint**: `/api/meals/:mealId`
- **Authentication**: Required
- **Body**:
```json
{
  "meal_name": "string",
  "carbohydrates": "number"
}
```
- **Response**:
```json
{
  "success": true
}
```

### Delete Meal Record
- **Method**: DELETE
- **Endpoint**: `/api/meals/:mealId`
- **Authentication**: Required
- **Response**:
```json
{
  "success": true
}
```

## User Settings Endpoints

### Get User Settings
- **Method**: GET
- **Endpoint**: `/api/settings`
- **Authentication**: Required
- **Response**:
```json
{
  "firebase_uid": "string",
  "insulin_sensitivity": "number",
  "carb_ratio": "number",
  "target_glucose_min": "number",
  "target_glucose_max": "number",
  "last_updated": "timestamp"
}
```

### Update User Settings
- **Method**: PUT
- **Endpoint**: `/api/settings`
- **Authentication**: Required
- **Body**:
```json
{
  "insulin_sensitivity": "number",
  "carb_ratio": "number",
  "target_glucose_min": "number",
  "target_glucose_max": "number"
}
```
- **Response**:
```json
{
  "success": true
}
```

## Example cURL Commands

### Get User Profile (with Firebase Token)
```bash
curl http://18.208.146.17:8080/api/users/profile \
  -H "Authorization: Bearer YOUR_FIREBASE_ID_TOKEN"
```

### Add Insulin Record (with Firebase Token)
```bash
curl -X POST http://18.208.146.17:8080/api/insulin \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_FIREBASE_ID_TOKEN" \
  -d '{"insulin_units": 5.5, "blood_glucose_level": 120, "notes": "Lunch dose"}'
```

### Get Insulin Records (with Firebase Token)
```bash
curl http://18.208.146.17:8080/api/insulin \
  -H "Authorization: Bearer YOUR_FIREBASE_ID_TOKEN"
```

### Update Settings (with Firebase Token)
```bash
curl -X PUT http://18.208.146.17:8080/api/settings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_FIREBASE_ID_TOKEN" \
  -d '{"insulin_sensitivity": 50, "carb_ratio": 15, "target_glucose_min": 80, "target_glucose_max": 130}'
```
