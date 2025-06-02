import { useState, useRef } from 'react';
import { getUploadUrl, checkStatus, fetchText } from './api';

export default function Upload() {
  const [status, setStatus] = useState("");
  const [text, setText]     = useState("");
  const poll = useRef();

  async function handle({ target }) {
    const file = target.files[0];
    if (!file) return;

    // 1. Get the signed URL (which in LOCAL_DEV is a dummy example.com URL)
    const { uploadUrl, fileId } = await getUploadUrl(file.name);

    // 2. If we're in LOCAL_DEV (uploadUrl points at example.com),
    //    skip the fetch() entirely:
    if (!uploadUrl.startsWith("https://example.com")) {
      // In “real” mode, we would do:
      await fetch(uploadUrl, {
        method: "PUT",
        body:   file,
        headers:{ "Content-Type": "application/pdf" }
      });
    }

    // 3. Immediately go to “processing” and start polling
    setStatus("processing");
    poll.current = setInterval(async () => {
      const { status } = await checkStatus(fileId);
      setStatus(status);
      if (status === "done") {
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