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

import React, { useEffect, useState } from "react";
import { AgGridReact } from "ag-grid-react";
import "ag-grid-community/dist/styles/ag-grid.css";
import "ag-grid-community/dist/styles/ag-theme-material.css";
import {
  Grid,
  Button,
} from "@mui/material";

//for appbar
import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import Box from "@material-ui/core/Box";
//for icons
import AddBoxRoundedIcon from "@mui/icons-material/AddBoxRounded";
import EditRoundedIcon from "@mui/icons-material/EditRounded";
import DeleteRoundedIcon from "@mui/icons-material/DeleteRounded";
import FileUploadRoundedIcon from "@mui/icons-material/FileUploadRounded";
import DownloadRoundedIcon from "@mui/icons-material/DownloadRounded";
//for back button redirect
import { useHistory } from "react-router-dom";
import "../../components/ag.css";
//alert message

import Popup from "./crudoperation";
import { getAllCrud, deleteCrud } from "../../service/crud.service";

import Snackbarcustom from "./Snackbar";

let gridApi;

const ProductinvoiceDetails = () => {
  const [successopen, setSuccessopen] = React.useState(false);
  const [snackbarmsg, setSnackbarmsg] = React.useState("");
  const [erroropen, setErroropen] = React.useState(false);

  // turns OFF row hover, it's on by default
  const suppressRowHoverHighlight = true;
  // turns ON column hover, it's off by default
  const columnHoverHighlight = true;
  const [rowData, setRowData] = useState([]);

  //for edit popup to change value
  const onChange = (e) => {
    const { value, id } = e.target;
    console.log(value, id);
    setFormData({ ...formData, [id]: value });
  };

  //refresh page
  const refreshPage = () => {
    window.location.reload(false);
  };

  useEffect(() => {
    invalidateCrud();
  }, []);

  const history = useHistory();

  //csv export
  const onGridReady = (params) => {
    gridApi = params.api;

    //  params.api.sizeColumnsToFit()
  };
  const onExportClick = () => {
    var params = {
      skipHeader: false,
      skipFooters: true,
      skipGroups: true,
      fileName: "Crud.csv",
    };
    gridApi.exportDataAsCsv(params);

    setSnackbarmsg("Data Downloaded SuccessFully");
    setSuccessopen(true);

    setTimeout(() => {
      setSuccessopen(false);
      setSnackbarmsg("");
    }, 2000);
  };

  const invalidateCrud = () => {
    getAllCrud()
      .then((res) => {
        console.log(res, "response collect");
        setRowData(res.data);
      })
      .catch((err) => {});
  };

  const [crudopen, setCrudopen] = useState(false);
  const [selecteddata, setSelecteddata] = useState(null);

  const handleAddopen = () => {
    const selectedRows = gridApi.selectionService.getSelectedRows();
    if (selectedRows.length === 0) {
      setCrudopen(true);
    } else {
      alert("Deselect the row to add new data!");
    }
  };

  const handleClose = () => {
    setCrudopen(false);
    setSelecteddata(null);
  };

  //Delete
  const handleDelete = () => {
    console.log(gridApi.selectionService.getSelectedRows());
    const selectedRows = gridApi.selectionService.getSelectedRows();
    if (selectedRows === undefined || selectedRows.length === 0) {
      alert("No rows were selected. Please select the row to delete!");
    } else {
      const confirm = window.confirm(
        "Are you sure, you want to delete this data"
      );
      if (confirm) {
        let numberOfDeletes = 0;
        selectedRows.forEach((row) => {
          const delete_id = row.crudid;
          deleteCrud(delete_id)
            .then((res) => {
              if (res.data.success === true) {
                setSnackbarmsg("Data has been Deleted SuccessFully");
                setSuccessopen(true);

                setTimeout(() => {
                  setSuccessopen(false);
                  setSnackbarmsg("Data has been Deleted SuccessFully");
                }, 2000);
              } else {
                setSnackbarmsg("Data has been Deleted SuccessFully");
                setSuccessopen(true);

                setTimeout(() => {
                  setSuccessopen(false);
                  setSnackbarmsg("Data has been Deleted SuccessFully");
                }, 2000);
              }

              console.log(res);
              numberOfDeletes++;
              if (numberOfDeletes === selectedRows.length) {
                invalidateCrud();
              }
            })
            .catch((error) => {
              // handle error
              console.log(error);
              setSnackbarmsg(error.response.data.message);
              setErroropen(true);

              setTimeout(() => {
                setErroropen(false);
                setSnackbarmsg("Data Deleted SuccessFully");
              }, 2000);
            })
            .then(() => {
              // always executed
              console.log("always");
            });
        });
      }
    }
  };

  const handleEditOpen = () => {
    const selectedRows = gridApi.selectionService.getSelectedRows();
    if (selectedRows === undefined || selectedRows.length === 0) {
      alert("Select a row to edit!");
    } else if (selectedRows.length >= 2) {
      alert("Select any one of the rows to edit!");
    } else {
      console.log("edit Response", selectedRows[0]);

      setCrudopen(true);
      setSelecteddata(selectedRows[0]);
    }
  };

  const colDefs = [
    {
      headerName: "",
      field: "pending",
      sortable: true,
      editable: true,
      checkboxSelection: true,
      headerCheckboxSelection: true,
      cellStyle: { "text-align": "center" },
      floatingFilter: false,
      filter: false,
      width: 70,
    },

    {
      headerName: "Priority",
      field: "priority",
      cellStyle: { "text-align": "center" },
      wrapText: true,
      headerClass: "customizeHeader",
    },
    {
      headerName: "Name",
      field: "name",
      cellStyle: { "text-align": "center" },
      wrapText: true,
      width: "267",
      height: "500",
      headerClass: "customizeHeader",
    },

    {
      headerName: "E-Mail",
      field: "email",
      cellStyle: { "text-align": "center" },
      wrapText: true,
      headerClass: "customizeHeader",
    },

    {
      headerName: "Mobile No",
      field: "mobno",
      cellStyle: { "text-align": "center" },
      wrapText: true,
      headerClass: "customizeHeader",
    },

    {
      headerName: "Name in Document",
      field: "docname",
      cellStyle: { "text-align": "center" },
      wrapText: true,
      headerClass: "customizeHeader",
    },

    {
      headerName: "Description",
      field: "description",
      cellStyle: { "text-align": "center" },
      wrapText: true,
      headerClass: "customizeHeader",
    },
  ];

  return (
    <div
      className="ag-theme-material"
      style={{ height: "70vh", margin: "5vh" }}
    >
      <AppBar position="static" class="appbarGlobal" style={{ width: "100%" }}>
        <Toolbar className="appcolor">
          <Box style={{ flexGrow: 1 }}>
            <div>
              <h1 className="title">Global Template</h1>
            </div>
          </Box>
          <div>
            <Grid>
              <div class="tooltip">
                <Button variant="text" onClick={handleAddopen} id="add">
                  <AddBoxRoundedIcon className="icon " />
                </Button>
                <span class="tooltiptext">Add</span>
              </div>

              <div class="tooltip">
                <Button variant="text" onClick={handleEditOpen} id="edit">
                  <EditRoundedIcon className="icon " />
                </Button>
                <span class="tooltiptext">Edit</span>
              </div>

              <div class="tooltip">
                <Button variant="text" onClick={handleDelete} id="delete">
                  <DeleteRoundedIcon className="icon " />
                </Button>
                <span class="tooltiptext">Delete</span>
              </div>

              <div class="tooltip">
                <Button
                  variant="text"
                  id="Upload"
                  disabled
                  // onClick={handleDelete}
                >
                  <FileUploadRoundedIcon className="icon " />
                </Button>
                {/* <span class="tooltiptext">Upload Data </span> */}
                <span class="tooltiptext">
                  Upload Data is Temporarly Unavailable
                </span>
              </div>

              <div class="tooltip">
                <Button variant="text" id="download" onClick={onExportClick}>
                  <DownloadRoundedIcon className="icon " />
                </Button>
                <span class="tooltiptext">Download</span>
              </div>
            </Grid>
          </div>
        </Toolbar>
      </AppBar>

      <Popup
        open={crudopen}
        handleClose={handleClose}
        invalidateCrud={invalidateCrud}
        selectedRowdata={selecteddata}
      />
      <br />
      <br />
      <br />
      <div style={{ width: "100%", height: "90%" }}>
        <AgGridReact
          style={{
            boxSizing: "border-box",
            height: "100%",
            width: "100%",
            textAlign: "center",
          }}
          pagination={true}
          rowSelection="multiple"
          rowMultiSelectWithClick={true}
          paginationPageSize={20}
          rowData={rowData}
          // rowMultiSelectWithClick={true}
          defaultColDef={{
            sortable: true,
            resizable: true,
            editable: false,
            suppressMovable: true,
            suppressMenu: true,
            filter: true,
            floatingFilter: true,
            // flex:1,//less than 9
            enableBrowserTooltips: true,
            autoHeight: true,
          }}
          onGridReady={onGridReady}
          columnHoverHighlight={columnHoverHighlight}
          columnDefs={colDefs}
        >
          {/* <AgGridColumn
            //  width="250px" 
            headerClass="customizeHeader"
            checkboxSelection={true}
            filter={false}
            floatingFilter={false}
            pinned='left'
            width="70"
            headerCheckboxSelection={true}
            headerCheckboxSelectionFilteredOnly={true}


          ></AgGridColumn>
          <AgGridColumn field="component_name" headerClass="customizeHeader" headerName=" Name" ></AgGridColumn>
          <AgGridColumn field="description" headerClass="customizeHeader" w headerName="Description"   ></AgGridColumn>
          <AgGridColumn field="payslip_name" headerClass="customizeHeader" headerName="Name in Pay Slip" ></AgGridColumn>
          <AgGridColumn field="pay_type" headerClass="customizeHeader" headerName="Pay Type" ></AgGridColumn>
          <AgGridColumn field="tax_type" headerClass="customizeHeader" headerName="Deduction Type"  ></AgGridColumn>

          <AgGridColumn field="calculation_type" headerClass="customizeHeader" headerName="Calculation Type"  ></AgGridColumn>
          <AgGridColumn field="is_active" headerClass="customizeHeader" headerName="Active"  ></AgGridColumn> */}
        </AgGridReact>
      </div>

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
};
export default ProductinvoiceDetails;
