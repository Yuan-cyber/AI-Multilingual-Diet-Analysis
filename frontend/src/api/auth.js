import axios from 'axios';

export async function login(username, password) {
  try {
    const res = await axios.post('/api/login', { username, password });
    return res.data;
  } catch (err) {
    throw new Error(err.response?.data?.error || 'fail to login, please try again');
  }
}

export async function register(username, password) {
  try {
    const res = await axios.post('/api/register', { username, password });
    return res.data;
  } catch (err) {
    throw new Error(err.response?.data?.error || 'fail to register, please try again');
  }
} 