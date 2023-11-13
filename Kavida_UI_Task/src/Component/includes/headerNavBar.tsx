import AccountCircleIcon from '@mui/icons-material/AccountCircle';

interface props {
    toggleSidebarUpdates(status?: boolean): void;
    initialState?: boolean,
    isMobile?: boolean;
}

function HeaderNavBar(props:any) {    
    return (<>
        <div className='d-flex justify-content-between align-items-center'>
            <div>
                <h3 className='headerHead'>Supplier Relationship Manager</h3>
            </div>
            <div className='col-md-3 d-flex justify-content-around align-items-center'>
                <div>Jones Ferdinand</div>
                <div className='avatarImg'>
                    <AccountCircleIcon />
                </div>
            </div>
        </div>
    </>);
}

export default HeaderNavBar;
