const video = document.getElementById("video");
const canvas = document.getElementById("canvas");
const ctx = canvas.getContext("2d");
const socket = io();

async function setupCamera() {
  const stream = await navigator.mediaDevices.getUserMedia({ video: true });
  video.srcObject = stream;

  video.addEventListener("loadedmetadata", () => {
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    sendVideoFrames();
  });
}

function sendVideoFrames() {
  ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

  const imageData = canvas.toDataURL("image/jpeg");
  const base64Data = imageData.split(",")[1];
  socket.emit("video_frame", atob(base64Data));

  requestAnimationFrame(sendVideoFrames);
}

socket.on("response_back", (data) => {
  const blob = new Blob([new Uint8Array(data)], { type: "image/jpeg" });
  const url = URL.createObjectURL(blob);

  const img = new Image();
  img.src = url;
  img.onload = () => {
    ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
    URL.revokeObjectURL(url);
  };
});

setupCamera();
