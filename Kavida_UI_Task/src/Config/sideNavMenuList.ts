import {route} from "./constants";
import {
    Business as BusinessIcon,
    DonutSmall  as IconLibraryBooks,
    AccountBalance as IconGroup,
    Storage as IconHowToReg,
    Ballot as IconSupply,
    Settings as IconSettings
}                   from '@mui/icons-material';

interface propsMenuItem {
    name: string;
    to: string;
}

export interface propsMenuList {
    name: string;
    to: string;
    icon?: any;
    sub?: propsMenuItem[];
}

export const navMenuList: propsMenuList[] = [
    {
        name: 'Command Centre',
        to  : route.home,
        icon: BusinessIcon
    },
    {
        name: 'Overview',
        to  : route.home,
        icon: IconLibraryBooks
    },
    {
        name: 'Supplier Financial Risk',
        to  : route.home,
        icon: IconGroup
    },
    {
        name: 'Intelligence',
        to  : route.home,
        icon: IconHowToReg
    },
    {
        name: 'Supplier Relationship Manager',
        to  : route.supplierRelationshipManagement,
        icon: IconSupply
    },
    {
        name: 'Settings',
        to  : route.home,
        icon: IconSettings
    }
];
