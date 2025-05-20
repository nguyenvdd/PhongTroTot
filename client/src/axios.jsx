import axios from "axios";

const instance = axios.create({
  baseURL: import.meta.env.VITE_SERVER_URL,
});

// Add a request interceptor
instance.interceptors.request.use(
  function (config) {
    let token = window.localStorage.getItem("phongtro");
    if (token) token = JSON.parse(token);
    if (token?.state?.token) {
      config.headers = {
        ...config.headers, // ⚠️ giữ lại các headers khác
        Authorization: `Bearer ${token.state.token}`,
      };
    }
    return config;
  },
  function (error) {
    return Promise.reject(error);
  }
);

// Add a response interceptor
instance.interceptors.response.use(
  function (response) {
    return response.data;
  },
  function (error) {
    return error.response?.data || Promise.reject(error);
  }
);

export default instance;
