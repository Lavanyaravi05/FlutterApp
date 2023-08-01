import axios from "axios";
// import axios from '@ipss/utils/lib/services/axios'

import { getApiUrl } from "../config";

export const getAllCrud = () => {
  const config = {
    method: "get",

    // for enambling client server page numbering

    baseURL: getApiUrl() + "/crud",

    //url: '/nhdydetail/'',

    headers: {
      "Content-Type": "application/json",
    },
  };

  return axios(config);
};

//get cred
export const getCrud = (crudid) => {
  const config = {
    method: "get",
    baseURL: getApiUrl() + "/crud/" + crudid + "/",

    headers: {
      "Content-Type": "application/json",
    },
  };
  return axios(config);
};

//add cred
export const addCrud = (crud = {}) => {
  const config = {
    method: "post",
    baseURL: getApiUrl() + "/crud/",
    headers: {
      "Content-Type": "application/json",
    },
    data: crud,
  };

  return axios(config);
};

//patch cred
export const editCrud = (submitdataset, crudid) => {
  const config = {
    method: "put",
    baseURL: getApiUrl() + "/crud/" + crudid,

    headers: {
      "Content-Type": "application/json",
    
    },
    data: submitdataset,
  };

  return axios(config);
};

//delete cred
export const deleteCrud = (crudid) => {
  const config = {
    method: "delete",
    baseURL: getApiUrl() + "/crud/" + crudid,

    headers: {
      "Content-Type": "application/json",
    },
  };

  return axios(config);
};
