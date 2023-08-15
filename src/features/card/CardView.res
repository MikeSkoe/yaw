module Option = Belt.Option;

@react.component
let make = (~card: Card.t) => {
    let id = card.id->Option.getWithDefault(0)->Int.toString;
    let deleteCard = CardRepository.useDeleteCard();

    <dl>
        <Link.Push hash=`view/${id}`>
            <h2>
                <span>{`${card.front} `->React.string}</span>
                <small>{card.level->Level.toString->React.string}</small>
            </h2>
            <p>{card.back->React.string}</p>
        </Link.Push>

        <button onClick={_ => deleteCard(card.id->Option.getWithDefault(0))->ignore}>
            {"delete"->React.string}
        </button>
    </dl>
}

