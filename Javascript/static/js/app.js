// from data.js
var tableData = data;


var tbody = d3.select("tbody");

function buildTable(data) {

  tbody.html("");


  data.forEach((line) => {

    var row = tbody.append("tr");

    Object.values(line).forEach((x) => {
      var tablecell = row.append("td");
        tablecell.text(x);
      }
    );
  });
}

function handleClick() {


  d3.event.preventDefault();

  var date = d3.select("#datetime").property("value");
  let filteredData = tableData;


  if (date) {

    filteredData = filteredData.filter(row => row.datetime === date);
  }

  buildTable(filteredData);
}

d3.selectAll("#filter-btn").on("click", handleClick);

buildTable(tableData);
