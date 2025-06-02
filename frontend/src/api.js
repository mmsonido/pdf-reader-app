const base = import.meta.env.VITE_API ?? "";
export const getUploadUrl = async f =>
  (await fetch(`${base}/upload-url?filename=`+encodeURIComponent(f))).json();
export const checkStatus  = async id =>
  (await fetch(`${base}/status/${id}`)).json();
export const fetchText    = async id =>
  (await fetch(`${base}/text/${id}`)).json();
