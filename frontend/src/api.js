export async function getUploadUrl(filename) {
  const r = await fetch(`/upload-url?filename=${encodeURIComponent(filename)}`);
  return r.json();
}
export async function checkStatus(id) {
  const r = await fetch(`/status/${id}`);
  return r.json();
}
export async function fetchText(id) {
  const r = await fetch(`/text/${id}`);
  return r.json();
}
