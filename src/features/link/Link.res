module Push = {
    @react.component
    let make = (~hash, ~id, ~children) =>
        <div onClick={_ => RescriptReactRouter.push(`${hash}/${id}`)}>
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
