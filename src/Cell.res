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
  for i in 0 to prevCells->Belt.Array.length - 1 {
    let totalLiveNeighbors = ref(0)

    // top left
    if prevCells->shouldIterate(i - colNumbers - 1) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // top middle
    if prevCells->shouldIterate(i - colNumbers) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // top right
    if prevCells->shouldIterate(i - colNumbers + 1) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // left
    if prevCells->shouldIterate(i - 1) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // right
    if prevCells->shouldIterate(i + 1) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // bottom left
    if prevCells->shouldIterate(i + colNumbers - 1) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // bottom middle
    if prevCells->shouldIterate(i + colNumbers) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }
    // bottom right
    if prevCells->shouldIterate(i + colNumbers + 1) {
      totalLiveNeighbors.contents = totalLiveNeighbors.contents + 1
    }

    let totalN = totalLiveNeighbors.contents
    let isAlive = switch prevCells->Belt.Array.get(i)->Belt.Option.getExn {
    | {isAlive: true} if totalN == 2 || totalN == 3 => true
    | {isAlive: false} if totalN == 3 => true
    | _ => false
    }
    let _ = newCells->Js.Array2.push({
      isAlive: isAlive,
      id: i,
    })
  }
  newCells
}
