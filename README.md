# Restaurant Menu Management API

A REST API built with **Ruby on Rails 8.1** and **MySQL** for managing restaurants and their menu items.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Ruby on Rails 8.1.2 |
| Language | Ruby 3.4 |
| Database | MySQL 8.x |
| Pagination | Kaminari |
| Server | Puma |

---

## Setup Instructions

### Prerequisites

- Ruby 3.4+
- Rails 8.1.2
- MySQL 8.x running locally
- Bundler

### 1. Clone & install dependencies

```bash
git clone <repo-url>
cd test-3
bundle install
```

### 2. Configure environment variables

Copy the example below and set your MySQL credentials:

```bash
export DB_USERNAME=root
export DB_PASSWORD=your_password
export DB_HOST=127.0.0.1
export DB_PORT=3306
```

Or create a `.env` file and use a gem like `dotenv-rails` (not included by default).

### 3. Create and migrate the database

```bash
bin/rails db:create
bin/rails db:migrate
```

### 4. Seed data

```bash
bin/rails db:seed
```

This creates 2 restaurants (Somboon Seafood, Gaggan Anand) with 5 menu items each.

### 5. Start the server

```bash
bin/rails server
```

The API is now available at `http://localhost:3000`.

---

## API Endpoints

### Restaurants

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/restaurants` | List all restaurants (paginated) |
| `POST` | `/restaurants` | Create a restaurant |
| `GET` | `/restaurants/:id` | Get restaurant detail (includes menu items) |
| `PUT` | `/restaurants/:id` | Update a restaurant |
| `DELETE` | `/restaurants/:id` | Delete a restaurant |

### Menu Items

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/restaurants/:id/menu_items` | List menu items (filter by category or name) |
| `POST` | `/restaurants/:id/menu_items` | Add a menu item to a restaurant |
| `PUT` | `/menu_items/:id` | Update a menu item |
| `DELETE` | `/menu_items/:id` | Delete a menu item |

---

## Request / Response Examples

### Create a Restaurant

```
POST /restaurants
Content-Type: application/json

{
  "restaurant": {
    "name": "The Noodle House",
    "address": "123 Silom Rd, Bangkok",
    "phone": "+66 2 000 0000",
    "opening_hours": "Mon-Sun 10:00 - 22:00"
  }
}
```

**Response 201**
```json
{
  "data": {
    "id": 3,
    "name": "The Noodle House",
    "address": "123 Silom Rd, Bangkok",
    "phone": "+66 2 000 0000",
    "opening_hours": "Mon-Sun 10:00 - 22:00"
  }
}
```

### List Menu Items (with filters)

```
GET /restaurants/1/menu_items?category=main&page=1
GET /restaurants/1/menu_items?name=pad+thai
```

**Response 200**
```json
{
  "data": [...],
  "meta": {
    "current_page": 1,
    "total_pages": 1,
    "total_count": 2,
    "per_page": 20
  }
}
```

### Add a Menu Item

```
POST /restaurants/1/menu_items
Content-Type: application/json

{
  "menu_item": {
    "name": "Green Curry",
    "description": "Creamy coconut green curry with chicken",
    "price": "220.00",
    "category": "main",
    "is_available": true
  }
}
```

Valid categories: `appetizer`, `main`, `dessert`, `drink`

---

## Validation & Error Responses

| Status | Scenario |
|--------|----------|
| `201 Created` | Successful resource creation |
| `200 OK` | Successful GET or update |
| `204 No Content` | Successful deletion |
| `404 Not Found` | Resource does not exist |
| `422 Unprocessable Entity` | Validation failed |

**Validation error example (422)**
```json
{
  "errors": [
    "Name can't be blank",
    "Price must be greater than or equal to 0"
  ]
}
```

---

## Optional Authentication (API Key)

Set the `API_KEY` environment variable to enable key-based auth:

```bash
export API_KEY=your-secret-key
```

All requests must then include the key via header:

```
X-API-Key: your-secret-key
# or
Authorization: Bearer your-secret-key
```

If `API_KEY` is not set, authentication is disabled (convenient for local development).

---

## Pagination

All list endpoints support pagination via query params:

| Param | Default | Description |
|-------|---------|-------------|
| `page` | 1 | Page number |
| `per_page` | 20 | Items per page |

---

## Design Decisions

- **No API namespace** — endpoints match the assignment spec exactly (`/restaurants`, `/menu_items`).
- **CSRF disabled for JSON** — `protect_from_forgery with: :null_session` so JSON clients don't need a CSRF token.
- **Soft boolean default** — `is_available` defaults to `true` at the DB level.
- **Idempotent seeds** — `find_or_create_by!` means `db:seed` can be run multiple times safely.
- **Optional auth** — API key auth only activates when `API_KEY` env var is set, making local dev frictionless.

---

## Docker (optional)

A `Dockerfile` is included. To run with Docker:

```bash
docker build -t restaurant-menu-api .
docker run -e DB_USERNAME=root -e DB_PASSWORD=secret -e DB_HOST=host.docker.internal \
  -p 3000:3000 restaurant-menu-api
```
