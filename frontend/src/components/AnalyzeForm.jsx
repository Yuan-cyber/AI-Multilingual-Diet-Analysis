import React, { useState, useEffect } from 'react';
import { analyze, getLanguages } from '../api/analyze';

function AnalyzeForm({ token }) {
  const [text, setText] = useState('');
  const [targetLanguage, setTargetLanguage] = useState('en');
  const [languages, setLanguages] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [result, setResult] = useState(null);

  // get supported languages
  useEffect(() => {
    getLanguages().then(setLanguages);
  }, []);
  
  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const res = await analyze(token, text, targetLanguage);
      setResult(res);
      setText('');
    } catch (err) {
      setError(err.message || 'fail to analyze, please try again');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="analyze-text">Food or menu description</label>
          <textarea
            id="analyze-text"
            value={text}
            onChange={e => setText(e.target.value)}
            placeholder="e.g., apple 200g, rice 300g"
            rows={4}
            required
          />
        </div>
        <div className="form-group">
          <label htmlFor="analyze-lang">Target language</label>
          <select
            id="analyze-lang"
            value={targetLanguage}
            onChange={e => setTargetLanguage(e.target.value)}
          >
            {languages.map(([code, name]) => (
              <option key={code} value={code}>{name}</option>
            ))}
          </select>
        </div>
        {error && <div className="error">{error}</div>}
        <button type="submit" disabled={loading || !text.trim()}>
          {loading ? 'analyzing...' : 'analyze'}
        </button>
      </form>
      
      {result && (
        <div className="result-panel" style={{ marginTop: '24px' }}>
          <div style={{ 
            fontSize: '1rem',
            fontWeight: 600, 
            background: 'linear-gradient(90deg, #4171d6 0%, #31b995 100%)',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            marginTop: 6, 
            textAlign: 'center' }}>Calorie Report from AI</div>
          <div style={{ 
            lineHeight: 1.4, 
            color: '#333', 
            padding: '16px 16px 0 16px',
          }}>
            {result.result}
          </div>
        </div>
      )}
    </div>
  );
}

export default AnalyzeForm; 