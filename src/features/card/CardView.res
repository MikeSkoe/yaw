module Option = Belt.Option;
module Int = Belt.Int;

@react.component
let make = (~card: Card.t) => {
    let deleteCard = CardRepository.useDeleteCard();
    let id = card->Card.getId;
    let front = card->Card.getFront;
    let back = card->Card.getBack;
    let level = card->Card.getLevel;

    <dl>
        <Link.Push hash=`view/${id->Int.toString}`>
            <h2>
                <span>{`${front} `->React.string}</span>
                <small>{level->Level.toString->React.string}</small>
            </h2>
            <p>{back->React.string}</p>
        </Link.Push>

        <button onClick={_ => id->deleteCard->ignore}>
            {"delete"->React.string}
        </button>
    </dl>
}

