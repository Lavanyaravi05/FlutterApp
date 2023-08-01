{
  /* File: 

     

Objective:The objective of this page is to show the all data in ag grid table

Description: this page shows cred list and add, edit delete optional CRED screen

Initiated By: Lavanya Ravi on 17th July...

Modification History

-------------------------------------------------------------------------------------------------------------------

DATE    |   	AUTHOR   	      |  	ModifiCation Request 	      		         |      Remarks / Details of Changes

--------------------------------------------------------------------------------------------------------------------
17-July-2023   Lavanya Ravi                   
---------------------------------------------------------------------------------------------------------------------

*/
}

/*react import*/
import React, { useState, useEffect } from "react";
/*material-ui icons*/
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";
import { styled } from "@mui/material/styles";
import Paper from "@mui/material/Paper";
import "../ag.css";
import Box from "@mui/material/Box";
import { Formik, Form } from "formik";
import Grid from "@mui/material/Grid";
import * as yup from "yup";

import Textfieldcustom from "./Textfield";

import { addCrud, editCrud } from "../../service/crud.service";

import Snackbarcustom from "./Snackbar";

export default function CrudOperation({
  open,
  handleClose,
  invalidateCrud,
  selectedRowdata,
}) {
  const [successopen, setSuccessopen] = React.useState(false);
  const [snackbarmsg, setSnackbarmsg] = React.useState("");
  const [erroropen, setErroropen] = React.useState(false);

  console.log(selectedRowdata, "popup");
  // ,optionaldata.find(option => option.value === selectedRowdata.pay_type))

  const registerFormSchema = yup.object({
    priority: yup.number().required("Field is required"),
    name: yup
      .string()
      .matches(
        /^[A-Za-z\s!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]+$/,
        "Only text is allowed"
      )
      .matches(
        /^(?!^\s+)(?!.*\s+$)(?=.*[A-Za-z])[A-Za-z\s!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]+$/,
        "Empty spaces are not allowed at the beginning or end"
      )
      .max(50, "Maximum 50 characters allowed")
      .required("Field is required"),
    email: yup.string().required("Field is required"),
    mobno: yup.number().required("Field is required"),
    docname: yup
      .string()
      .matches(
        /^[A-Za-z\s!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]+$/,
        "Only text is allowed"
      )
      .matches(
        /^(?!^\s+)(?!.*\s+$)(?=.*[A-Za-z])[A-Za-z\s!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]+$/,
        "Empty spaces are not allowed at the beginning or end"
      )
      .max(50, "Maximum 50 characters allowed")
      .required("Field is required"),

    description: yup.string().max(200, "Maximum 200 characters allowed"),
  });

  const [otherded, setOtherded] = useState(false);
  const [otherstat, setOtherstat] = useState(false);

  useEffect(() => {
    Health(selectedRowdata);
  }, [selectedRowdata]);

  const Health = (selectedRowdata) => {
    if (selectedRowdata === null) {
      ("");
    } else {
      console.log(
        selectedRowdata.other_deduction,
        "adsad",
        selectedRowdata.pay_type
      );
      setOtherded(selectedRowdata.other_deduction);

      if (selectedRowdata.pay_type === "Fixed") {
        setOtherstat(true);
      }
    }
  };

  const initialValues =
    selectedRowdata === null
      ? {
          priority: "",
          name: "",
          email: "",
          mobnon: "",
          docname: "",
          description: "",
        }
      : {
          priority: selectedRowdata.priority,
          name: selectedRowdata.name,
          email: selectedRowdata.email,
          mobno: selectedRowdata.mobno,
          docname: selectedRowdata.docname,
          description: selectedRowdata.description,
        };

  //identify the other deduction status

  const handleChange = () => {
    setOtherded(!otherded);
  };

  const handleSubmit = (values) => {
    const submitdataset = {
      priority: values.priority,
      name: values.name,
      email: values.email,
      mobno: values.mobno,
      docname: values.docname,
      description: values.description,
    };

    if (selectedRowdata === null) {
      AddCrudPost(submitdataset);
    } else {
      EditCrudPost(submitdataset);
    }
    // console.log("values",submitdataset,)
  };

  const AddCrudPost = (submitdataset) => {
    addCrud(submitdataset)
      .then((res) => {
        // handle success
        console.log(res);

          setSnackbarmsg("Data has been created successfully");
          setSuccessopen(true);

          setTimeout(() => {
            setSuccessopen(false);
            setSnackbarmsg("Data has been created successfully");

            handleClose();
            invalidateCrud();
          }, 2000);
          setSnackbarmsg("Data has been created successfully");
          setSuccessopen(true);

          setTimeout(() => {
            setErroropen(false);
            setSnackbarmsg("Unsuccessfully");
          }, 2000);
        
      })
      .catch((error) => {
        // handle error

        console.log(error);
        setSnackbarmsg(error.response.data.message);
        setErroropen(true);

        setTimeout(() => {
          setErroropen(false);
          setSnackbarmsg("");
          setOtherstat(false);
        }, 2000);

        //   console.log(error.response.data.message);
      })
      .then(() => {
        // always executed
        console.log("always");
      });
  };

  const EditCrudPost = (submitdataset) => {
    editCrud(
      submitdataset,
      selectedRowdata.crudid
    )
      .then((res) => {
        // handle success
        console.log(res);

        if (res.data.success === true) {
          setSnackbarmsg("Data has been Updated Successfully");
          setSuccessopen(true);

          setTimeout(() => {
            setSuccessopen(false);
            setSnackbarmsg("Data has been Updated Successfully");

            handleClose();
            invalidateCrud();
            setOtherstat(false);
          }, 2000);
        } else {
          setSnackbarmsg("Data has been Updated Successfully");
          setSuccessopen(true);
          setTimeout(() => {
            setSuccessopen(false);
            handleClose();

            setSnackbarmsg("Data has been Updated Successfully");
          }, 2000);
        }
      })
      .catch((error) => {
        // handle error

        console.log(error);
        setSnackbarmsg("Unsuccessfully");
        setErroropen(true);

        setTimeout(() => {
            setSuccessopen(true);
          setSnackbarmsg("Data has been Updated Successfully");
        }, 2000);
      })
      .then(() => {
        // always executed
        console.log("always");
      });
  };

  const fixedstat = () => {
    setOtherstat(true);
  };
  const variablestat = () => {
    setOtherstat(false);
  };

  const Item = styled(Paper)(({ theme }) => ({
    backgroundColor: theme.palette.mode === "dark" ? "#1A2027" : "#fff",
    ...theme.typography.body2,
    padding: theme.spacing(1),
    textAlign: "center",
    color: theme.palette.text.secondary,
  }));

  /*return function start*/
  return (
    <div>
      <Dialog
        open={open}
        // onClose={handleClose}
        aria-labelledby="alert-dialog-title"
        aria-describedby="alert-dialog-description"
      >
        <Formik
          initialValues={initialValues}
          validationSchema={registerFormSchema}
          onSubmit={handleSubmit}
        >
          <Form>
            <DialogTitle id="alert-dialog-title">
              {selectedRowdata === null ? "Add Data" : "Edit Data"}
            </DialogTitle>
            <DialogContent>
              <DialogContentText id="alert-dialog-description">
                <br />

                <Box sx={{ flexGrow: 1 }}>
                  <Grid container spacing={2}>
                    <Grid item xs={6}>
                      <Textfieldcustom name="priority" labelname={"Priority"} />
                    </Grid>

                    <Grid item xs={6}>
                      <Textfieldcustom name="name" labelname={"Name"} />
                    </Grid>

                    <Grid item xs={6}>
                      <Textfieldcustom name="email" labelname={"E-Mail"} />
                    </Grid>

                    <Grid item xs={6}>
                      <Textfieldcustom name="mobno" labelname={"Mobile No"} />
                    </Grid>

                    <Grid item xs={6}>
                      <Textfieldcustom
                        name="docname"
                        labelname={"Name in Document"}
                      />
                    </Grid>
                    <Grid item xs={6}>
                      <Textfieldcustom
                        name="description"
                        labelname={"Description"}
                      />
                    </Grid>
                  </Grid>
                </Box>
                <br />
              </DialogContentText>
            </DialogContent>
            {/* </form> */}
            <DialogActions className="sub_cancel_button">
              <Button
                variant="outlined"
                id="cancel"
                style={{ width: "200px", color: "black" }}
                onClick={() => {
                  handleClose();
                }}
              >
                Cancel
              </Button>

              <Button
                variant="outlined"
                id="submit"
                type="submit"
                style={{
                  backgroundColor: "#0B2948",
                  width: "200px",
                  color: "white",
                }}
                
              >
                Submit
              </Button>
            </DialogActions>
          </Form>
        </Formik>
      </Dialog>
      <Snackbarcustom
        severity="success"
        snackbaropen={successopen}
        snackbarmsg={snackbarmsg}
      />
      <Snackbarcustom
        severity="error"
        snackbaropen={erroropen}
        snackbarmsg={snackbarmsg}
      />
    </div>
  );
  /*return function end*/
}
