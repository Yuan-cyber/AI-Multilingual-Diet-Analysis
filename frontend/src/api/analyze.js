import axios from 'axios';

export async function analyze(token, text, target_language) {
  try {
    const res = await axios.post('/api/analyze', { text, target_language }, {
      headers: { Authorization: `Bearer ${token}` }
    });
    return res.data;
  } catch (err) {
    throw new Error(err.response?.data?.error || 'fail to analyze, please try again');
  }
}

export async function getLanguages() {
  try {
    const res = await axios.get('/api/languages');
    return Object.entries(res.data.languages);
  } catch {
    return [['en', 'English'], ['zh', '中文']];
  }
}