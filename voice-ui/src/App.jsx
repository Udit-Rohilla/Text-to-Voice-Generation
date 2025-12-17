import { useState } from "react"
import "./App.css"

const API_BASE = "http://localhost:3000/api/v1"

export default function App() {
  const [text, setText] = useState("")
  const [status, setStatus] = useState(null)
  const [currentAudio, setCurrentAudio] = useState(null)
  const [history, setHistory] = useState([])
  const [loading, setLoading] = useState(false)

  const [confirmAction, setConfirmAction] = useState(null)
  const [removingId, setRemovingId] = useState(null)

  const createRequest = async () => {
    setLoading(true)
    setStatus("pending")
    setCurrentAudio(null)

    const res = await fetch(`${API_BASE}/voice_requests`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        voice_request: { input_text: text }
      })
    })

    const data = await res.json()
    pollStatus(data.id)
  }

  const pollStatus = (id) => {
    const interval = setInterval(async () => {
      const res = await fetch(`${API_BASE}/voice_requests/${id}`)
      const data = await res.json()

      setStatus(data.status)

      if (data.status === "success") {
        setCurrentAudio(data)
        setHistory((prev) => [data, ...prev])
        setLoading(false)
        clearInterval(interval)
      }

      if (data.status === "failed") {
        setLoading(false)
        clearInterval(interval)
      }
    }, 1500)
  }

  const formatTime = (iso) => {
    return new Date(iso).toLocaleString()
  }

  const confirmDelete = () => {
    if (confirmAction?.type === "single") {
      setRemovingId(confirmAction.id)

      setTimeout(() => {
        setHistory((prev) =>
          prev.filter((item) => item.id !== confirmAction.id)
        )
        setRemovingId(null)
        setConfirmAction(null)
      }, 300)
    }

    if (confirmAction?.type === "clear") {
      setHistory([])
      setConfirmAction(null)
    }
  }

  return (
    <>
      <div className="page">
        <div className="card">
          <h1>Text to Speech Generator</h1>

          <textarea
            rows="4"
            maxLength="500"
            value={text}
            onChange={(e) => setText(e.target.value)}
            placeholder="Enter text to generate voice"
          />

          <div className="controls">
            <span className="counter">{text.length}/500</span>

            <button onClick={createRequest} disabled={loading || !text}>
              {loading ? "Generating..." : "Generate"}
            </button>
          </div>

          {status && (
            <div className={`status ${status}`}>
              {status}
            </div>
          )}

          {currentAudio && (
            <div className="audio-card">
              <p>Latest audio</p>
              <audio controls src={currentAudio.audio_url} />
            </div>
          )}

          <div className="history">
            <h2>History</h2>

            {history.length > 0 && (
              <button
                className="clear-btn"
                onClick={() =>
                  setConfirmAction({ type: "clear" })
                }
              >
                Clear history
              </button>
            )}

            {history.length === 0 && (
              <p className="empty">
                No audio yet. Generate your first voice above.
              </p>
            )}

            {history.map((item) => (
              <div
                key={item.id}
                className={`audio-card history-item ${
                  removingId === item.id ? "removing" : ""
                }`}
              >
                <div className="history-header">
                  <div>
                    <p className="text-preview">{item.input_text}</p>
                    <span className="timestamp">
                      {formatTime(item.created_at)}
                    </span>
                  </div>

                  <button
                    className="delete-btn"
                    onClick={() =>
                      setConfirmAction({
                        type: "single",
                        id: item.id
                      })
                    }
                  >
                    ✕
                  </button>
                </div>

                <audio controls src={item.audio_url} />
              </div>
            ))}
          </div>
        </div>
      </div>

      {confirmAction && (
        <div className="modal-overlay">
          <div className="modal">
            <h3>
              {confirmAction.type === "clear"
                ? "Clear all history?"
                : "Delete audio?"}
            </h3>

            <p>
              {confirmAction.type === "clear"
                ? "This will remove all generated audio history."
                : "This action cannot be undone."}
            </p>

            <div className="modal-actions">
              <button
                className="cancel-btn"
                onClick={() => setConfirmAction(null)}
              >
                Cancel
              </button>

              <button
                className="danger-btn"
                onClick={confirmDelete}
              >
                Delete
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  )
}
