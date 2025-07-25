import React, { useState } from 'react';
import './App.css';
import LoginForm from './components/LoginForm';
import RegisterForm from './components/RegisterForm';
import AnalyzeForm from './components/AnalyzeForm';
import { FiLogOut } from 'react-icons/fi';

function App() {
  const [tab, setTab] = useState('login');
  const [token, setToken] = useState('');
  const [user, setUser] = useState(null);

  // callback after login
  const handleLogin = (token, user) => {
    setToken(token);
    setUser(user);
    setTab('analyze');
  };

  const handleRegister = () => {
    setTab('login');
  };

  const handleLogout = () => {
    setToken('');
    setUser(null);
    setTab('login');
  };

  return (
    <>
      <h1 className="main-title">AI Multilingual Diet Analysis Assistant</h1>
      <div className="app-container">
        {user && (
          <div style={{ textAlign: 'right', display: 'flex', alignItems: 'center', justifyContent: 'flex-end'}}>
            <span style={{ color: '#4171d6', fontWeight: 500 }}>Hi, {user.username}</span>
            <button className="logout-btn" onClick={handleLogout} style={{
              background: 'none', 
              boxShadow: 'none', 
              padding: 0, 
              marginLeft: 0,
              display: 'flex', 
             }} title="Logout">
              <FiLogOut />
            </button>
          </div>
        )}
        {!user && (
          <h2 style={{ fontSize: '1.5rem', color: '#4171d6', textAlign: 'center', margin: '0 0 16px 0' }}>
            {tab === 'login' ? 'Login' : 'Register'}
          </h2>
        )}
        {tab === 'login' && !user && <LoginForm onLogin={handleLogin} onSwitchToRegister={() => setTab('register')} />}
        {tab === 'register' && !user && <RegisterForm onRegister={handleRegister} onSwitchToLogin={() => setTab('login')} />}
        {tab === 'analyze' && user && (
          <>
            <div style={{
    fontSize: '1.2rem',
    textAlign: 'center',
    marginBottom: 12,
    background: 'linear-gradient(90deg, #4171d6 0%, #31b995 100%)',
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
    fontWeight: 700
  }}>
            Check Calories in Your Food
            </div>
            <AnalyzeForm token={token} />
          </>
        )}
      </div>
    </>
  );
}

export default App; 