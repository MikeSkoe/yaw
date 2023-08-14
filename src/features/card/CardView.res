@react.component
let make = (~card: Card.t, ~children: option<React.element>=?) =>
    <div key={card.id->Option.getWithDefault(0)->Int.toString}>
        <p>{card.front->React.string}</p>
        <p>{card.back->React.string}</p>
        <p>{`level: ${card.level->Level.toString}`->React.string}</p>
        {children->Option.getWithDefault(<></>)}
    </div>

