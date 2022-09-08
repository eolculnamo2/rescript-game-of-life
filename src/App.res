%%raw(`import './App.css';`)
@module("./logo.svg") external logo: string = "default"

let colNumber = 100
let rowNumber = 100
let cellSize = 10 // px
let iterationMs = 250
let totalCells = colNumber * rowNumber
type state = {cells: array<Cell.t>}
let state = {
  cells: [],
}
type actions = HandleCellInterval

let reducer = (state, action) => {
  switch action {
  | HandleCellInterval => {
      cells: Cell.handleInterval(state.cells, colNumber)
    }
  }
}

let randomCells = Cell.randomizeCells(totalCells)
let cellSizePx = cellSize->Belt.Int.toString ++ "px"
@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(
    reducer,
    {
      cells: randomCells,
    },
  )

  React.useEffect0(() => {
    let _ = Js.Global.setInterval(() => {
      dispatch(HandleCellInterval)
    }, iterationMs)
    None
  })

  <div className="App">
    <div
      style={ReactDOM.Style.make(
        ~display="flex",
        ~flexWrap="wrap",
        ~width=(colNumber * cellSize)->Belt.Int.toString ++ "px",
        (),
      )}>
      {state.cells
      ->Belt.Array.map(c => {
        <div
          key={c.id->Belt.Int.toString}
          style={ReactDOM.Style.make(
            ~backgroundColor=c.isAlive ? "green" : "gray",
            ~height=cellSizePx,
            ~width=cellSizePx,
            (),
          )}
        />
      })
      ->React.array}
    </div>
  </div>
}
