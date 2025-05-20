import React from "react"
import ReactDOM from "react-dom/client"
import "./index.css"
import App from "~/App"
import { BrowserRouter } from "react-router-dom"
import { GoogleOAuthProvider } from "@react-oauth/google"

const clientId = import.meta.env.VITE_GOOGLE_CLIENT_ID // nếu dùng Vite
// hoặc với Create React App: process.env.REACT_APP_GOOGLE_CLIENT_ID

ReactDOM.createRoot(document.getElementById("root")).render(
  <GoogleOAuthProvider clientId={clientId}>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </GoogleOAuthProvider>
)
