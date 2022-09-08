type t = {
  isAlive: bool,
  id: int,
}

let randomizeCells = totalCells => {
  let cellArray: array<t> = []
  for i in 0 to totalCells - 1 {
    let isAlive = Js.Math.random_int(0, 2) == 1
    let cell = {
      isAlive: isAlive,
      id: i,
    }
    let _ = cellArray->Js.Array2.push(cell)
  }
  cellArray
}

let shouldIterate = (prevCells, index) => {
  switch prevCells->Belt.Array.get(index) {
  | Some(c) if c.isAlive => true
  | _ => false
  }
}
let handleInterval = (prevCells, colNumbers) => {
  let newCells: array<t> = []
  let shouldIterateCells = shouldIterate(prevCells)
  for i in 0 to prevCells->Belt.Array.length - 1 {
    let totalLiveNeighbors = ref(0)

    // top left
    if shouldIterateCells(i - colNumbers - 1) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // top middle
    if shouldIterateCells(i - colNumbers) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // top right
    if shouldIterateCells(i - colNumbers + 1) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // left
    if shouldIterateCells(i - 1) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // right
    if shouldIterateCells(i + 1) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // bottom left
    if shouldIterateCells(i + colNumbers - 1) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // bottom middle
    if shouldIterateCells(i + colNumbers) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // bottom right
    if shouldIterateCells(i + colNumbers + 1) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }

    let currentCell = prevCells->Belt.Array.get(i)->Belt.Option.getExn
    let totalN = totalLiveNeighbors.contents

    let isAlive = switch (currentCell, totalN) {
    | ({isAlive: true}, 2 | 3) => true
    | ({isAlive: false}, 3) => true
    | _ => false
    }

    let _ = newCells->Js.Array2.push({
      isAlive: isAlive,
      id: i,
    })
  }
  newCells
}
