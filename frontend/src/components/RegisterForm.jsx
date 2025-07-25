import React, { useState } from 'react';
import { register } from '../api/auth';

function RegisterForm({ onRegister, onSwitchToLogin }) {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [message, setMessage] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    setMessage('');

    try {
      const result = await register(username, password);
      if (result.message) {
        setMessage(result.message);
        // Clear form after successful registration
        setUsername('');
        setPassword('');
        onRegister(); // Navigate to login page
      } else {
        setError('fail to register');
      }
    } catch (err) {
      setError(err.response?.data?.error || 'fail to register');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <div className="form-group">
        <label htmlFor="register-username">Username</label>
        <input
          id="register-username"
          type="text"
          value={username}
          onChange={e => setUsername(e.target.value)}
          required
        />
      </div>
      <div className="form-group">
        <label htmlFor="register-password">Password</label>
        <input
          id="register-password"
          type="password"
          value={password}
          onChange={e => setPassword(e.target.value)}
          required
        />
      </div>
      {error && <div className="error">{error}</div>}
      {message && <div className="success">{message}</div>}
      <button type="submit" disabled={loading}>
        {loading ? 'registering...' : 'register'}
      </button>
      <div className="register-link">
        Already have an account? <span onClick={onSwitchToLogin}>Login here</span>
      </div>
    </form>
  );
}

export default RegisterForm; 