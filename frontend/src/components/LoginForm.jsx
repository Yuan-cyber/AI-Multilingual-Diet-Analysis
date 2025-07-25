import React, { useState } from 'react';
import { login } from '../api/auth';

const LoginForm = ({ onLogin, onSwitchToRegister }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const result = await login(username, password);
      if (result.token) {
        localStorage.setItem('token', result.token);
        onLogin(result.token, result.user);
      } else {
        setError('fail to login');
      }
    } catch (err) {
      setError(err.response?.data?.error || 'fail to login');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <div className="form-group">
        <label>Username</label>
        <input
          type="text"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          required
        />
      </div>
      <div className="form-group">
        <label>Password</label>
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />
      </div>
      {error && <div className="error">{error}</div>}
      <button type="submit" disabled={loading}>
        {loading ? 'logging in...' : 'login'}
      </button>
      <div className="register-link">
        Don't have an account yet? <span onClick={onSwitchToRegister}>Register here</span>
      </div>
    </form>
  );
};

export default LoginForm; 