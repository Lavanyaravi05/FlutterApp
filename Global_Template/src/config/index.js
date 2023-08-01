export const getApiUrl = () => {
    switch (process.env.NODE_ENV) {
        case "development":
            return "https://632417cc5c1b435727a074f9.mockapi.io"
        case "production":
            return "https://632417cc5c1b435727a074f9.mockapi.io"
            
        default:
            return "https://632417cc5c1b435727a074f9.mockapi.io"
            //return "https://pghrmapi.techgenzi.com/"
    }
}
// export const PROJECT_ID = "Nhmas"