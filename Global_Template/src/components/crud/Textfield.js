import React from 'react';
import TextField from '@mui/material/TextField';
import { useFormikContext, getIn } from 'formik';

const MyTextField = ({ name, labelname, type = 'text' }) => {
  const { values, errors, touched, handleChange, handleBlur } = useFormikContext();

  const fieldValue = getIn(values, name);
  const fieldError = getIn(errors, name);
  const fieldTouched = getIn(touched, name);
  // console.log(errors,"err")
  return (
    <TextField
      type={type}
      name={name}
      id={name}
      //   size='small'
      label={labelname}
      fullWidth
      variant="outlined"
      value={fieldValue}
      onChange={handleChange}
      onBlur={handleBlur}
      error={fieldTouched && !!fieldError}
      helperText={fieldTouched && fieldError}
      InputLabelProps={type === 'time' || "date" ? { shrink: true } : {}}

    />
  );
};

export default MyTextField;