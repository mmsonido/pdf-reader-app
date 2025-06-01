import { useState, useRef } from 'react';
import { getUploadUrl, checkStatus, fetchText } from './api';

export default function Upload() {
  const [status, setStatus] = useState('');
  const [text, setText]   = useState('');
  const poll = useRef(null);

  async function handle(e) {
    const file = e.target.files[0];
    if (!file) return;

    const { uploadUrl, fileId } = await getUploadUrl(file.name);
    await fetch(uploadUrl, {
      method: 'PUT',
      body: file,
      headers: { 'Content-Type': 'application/pdf' },
    });
    setStatus('processing');

    poll.current = setInterval(async () => {
      const { status } = await checkStatus(fileId);
      setStatus(status);
      if (status === 'done') {
        clearInterval(poll.current);
        const { text } = await fetchText(fileId);
        setText(text);
      }
    }, 2000);
  }

  return (
    <div className="p-6">
      <input type="file" accept="application/pdf" onChange={handle} />
      {status && <p>Status: {status}</p>}
      {text && <pre className="whitespace-pre-wrap border p-4 mt-4">{text}</pre>}
    </div>
  );
}
