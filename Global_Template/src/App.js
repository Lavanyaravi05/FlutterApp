import React , {useEffect}from 'react';
import { Switch, Route, Router } from 'react-router-dom';
import { StylesProvider, createGenerateClassName } from '@material-ui/core/styles';


import Crud from './components/crud/maintable';

const generateClassName = createGenerateClassName({
    productionPrefix: 'Crud',
});



export default ({ history }) => {
 
    return <div>
        <StylesProvider generateClassName={generateClassName}>
            <Router history={history}>
                <Switch>
            
                    <Route path="/">  <Crud/>  </Route> 

                    <Route path="/Crud">  <Crud/>  </Route> 

                 
                </Switch>
            </Router>
        </StylesProvider>
    </div>
};