import React from 'react';
import logo from './logo.svg';
import {BrowserRouter}  from "react-router-dom";
import AppRoute         from "./Routes/appRouter";
import './Assets/style.scss';

function App() {
  return (
    <>
      <BrowserRouter>
        <AppRoute />
      </BrowserRouter>
    </>
  );
}

export default App;
