# AI Multilingual Diet Analysis Assistant

This is an AI-powered multilingual diet analysis assistant that helps users analyze food calories in multiple languages.
<img width="1770" height="1238" alt="image" src="https://github.com/user-attachments/assets/944afb33-3ccd-40e7-a35b-8e6f1e62e991" />
<img width="1770" height="1242" alt="image" src="https://github.com/user-attachments/assets/2c6db02a-e656-4d41-b77e-6ae9cf5a6ce5" />



## Features

- AI-powered food calorie analysis
- Multilingual input and output
- User registration, login, and authentication

## Design Considerations

- **User Experience**: Soft color palette and clean layout
- **Architecture**: Clear separation of concerns between frontend and backend with service layer pattern
- **Security**: JWT authentication, encrypted password storage, secure API validation
- **Persistence**: SQLite database for data management

## Requirements

- **Frontend**: React 18, Vite 5, Node.js 16+
- **Backend**: Ruby 3.0+, Sinatra 3, SQLite3
- Google Gemini API key

## Setup Instructions

1. **Clone the repo**
   ```bash
   git clone <your-repo-url>
   cd Coding_Exercise
   ```
2. **Backend dependencies**
   ```bash
   cd backend
   bundle install
   # Setup .env file with Gemini API Key and JWT_SECRET
   ruby db/migrate.rb
   ruby app.rb
   ```
3. **Frontend dependencies**
   ```bash
   cd ../frontend
   npm install
   npm run dev
   ```
4. **Access the app**
   Open your browser and go to [http://localhost:3000]

## Testing

- Backend integration tests are located in `backend/spec/core_test.rb`.
- To run backend tests:
  ```bash
  cd backend
  ruby spec/core_test.rb
  ```
- The tests cover user registration, login, authentication, and AI analysis endpoints.

---

For any questions, feel free to contact the developer.
