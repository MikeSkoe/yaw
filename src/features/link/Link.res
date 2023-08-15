module Push = {
    @react.component
    let make = (~hash, ~children) =>
        <div onClick={_ => RescriptReactRouter.push(hash)}>
            {children}
        </div>
}

module Replace = {
    @react.component
    let make = (~hash, ~children) =>
        <div onClick={_ => RescriptReactRouter.replace(hash)}>
            {children}
        </div>
}
