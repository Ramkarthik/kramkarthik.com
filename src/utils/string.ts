export const capitalize =(input: string) => {
    return !input ? input : (input.substring(0,1).toUpperCase() + input.substring(1,input.length))
}