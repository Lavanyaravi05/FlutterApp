import { Nav } from "react-bootstrap";
import logo from '../../Assets/images/logo.jpg';
import BusinessIcon from '@mui/icons-material/Business';
import DonutSmallIcon from '@mui/icons-material/DonutSmall';
import AccountBalanceIcon from '@mui/icons-material/AccountBalance';
import StorageIcon from '@mui/icons-material/Storage';
import BallotIcon from '@mui/icons-material/Ballot';
import SettingsIcon from '@mui/icons-material/Settings';

export default function Index() {
    return(<>
        <div className="col-md-12">
            <Nav className="flex-column d-flex justify-content-between sideNavTab" defaultActiveKey="link-5" as="ul">
                <Nav.Item className='col-md-12' as="li">
                    <Nav.Link eventKey="link">
                        <img className="w-100" src={logo} />
                    </Nav.Link>
                </Nav.Item>
                <Nav.Item className='col-md-12' as="li">
                    <Nav.Link className="d-flex align-items-center" eventKey="link-1">
                        <div>
                            <BusinessIcon className='pR-2 navIcon' />
                        </div>
                        <div className="icoName">
                            Command Centre
                        </div>
                    </Nav.Link>
                </Nav.Item>
                <Nav.Item className='col-md-12' as="li">
                    <Nav.Link className="d-flex align-items-center" eventKey="link-2">
                        <div>
                            <DonutSmallIcon className='pR-2 navIcon' />
                        </div>
                        <div className="icoName">
                            Overview
                        </div>
                    </Nav.Link>
                </Nav.Item>
                <Nav.Item className='col-md-12' as="li">
                    <Nav.Link className="d-flex align-items-center" eventKey="link-3">
                        <div>
                            <AccountBalanceIcon className='pR-2 navIcon' />
                        </div>
                        <div className="icoName">
                            Supplier Financial Risk
                        </div>
                    </Nav.Link>
                </Nav.Item>
                <Nav.Item className='col-md-12' as="li">
                    <Nav.Link className="d-flex align-items-center" eventKey="link-4">
                        <div>
                            <StorageIcon className='pR-2 navIcon' />
                        </div>
                        <div className="icoName">
                            Intelligence
                        </div>
                    </Nav.Link>
                </Nav.Item>
                <Nav.Item className='col-md-12' as="li">
                    <Nav.Link className="d-flex align-items-center" eventKey="link-5">
                        <div>
                            <BallotIcon className='pR-2 navIcon' />
                        </div>
                        <div className="icoName">
                            Supplier Relationship Manager
                        </div>
                    </Nav.Link>
                </Nav.Item>
                <Nav.Item className='col-md-12' as="li">
                    <Nav.Link className="d-flex align-items-center" eventKey="link-6">
                        <div>
                            <SettingsIcon className='pR-2 navIcon' />
                        </div>
                        <div className="icoName">
                            Settings
                        </div>
                    </Nav.Link>
                </Nav.Item>
            </Nav>
        </div>
    </>)
}