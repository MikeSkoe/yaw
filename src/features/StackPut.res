@react.component
let make = () => {
    let (value, setValue) = React.useState(_ => "");
    let putStack = StackRepository.usePutStack();
    let onValue = (fn, event) => fn(ReactEvent.Form.target(event)["value"]);
    let onClick = _ => {
        // TODO: implement validated stack type
        if value != "" {
            putStack(Stack.make(Stack.makeId(), value, list{}));
            Js.log("Saved!");
        }
        Js.log("Type longer name");
    }

    <div>
        <input value onChange=onValue(setValue) />
        <button onClick>{"Submit"->React.string}</button>
    </div>
}

