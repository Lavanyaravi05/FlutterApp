import axios from "axios";

let instance = axios.create({
    baseURL: "https://pghrmapi.techgenzi.com/",
    headers: {
        "Content-type": "application/json"
    }
});
const isDevEnv = window.location.href.includes('localhost') ? true : false;
if (isDevEnv) {
   initializeAxiosMockAdapter(instance);
}
export const Http = instance;