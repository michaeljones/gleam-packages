import gleam/bit_builder.{BitBuilder}
import gleam/list
import nakai
import nakai/html.{Node}
import nakai/html/attrs
import packages/index.{PackageSummary}

pub fn packages_list(
  packages: List(PackageSummary),
  search_term: String,
) -> BitBuilder {
  html.main(
    [],
    [
      html.header(
        [attrs.class("site-header")],
        [
          html.nav(
            [attrs.class("content")],
            [
              html.a([attrs.href("/")], [html.h1_text([], "Gleam Packages")]),
              search_form(search_term),
            ],
          ),
        ],
      ),
      html.div([attrs.class("content")], [package_list(packages)]),
    ],
  )
  |> layout
  |> nakai.render
  |> bit_builder.from_string
}

fn search_form(search_term: String) -> Node(t) {
  html.form(
    [attrs.class("search-form"), attrs.Attr("method", "GET")],
    [
      html.input([
        attrs.name("search"),
        attrs.type_("search"),
        attrs.value(search_term),
      ]),
      html.input([attrs.type_("submit"), attrs.value("🔎")]),
    ],
  )
}

fn package_list(packages: List(PackageSummary)) -> Node(t) {
  html.ul([attrs.class("package-list")], list.map(packages, package_list_item))
}

fn package_list_item(package: PackageSummary) -> Node(t) {
  let url = "https://hex.pm/packages/" <> package.name
  html.li(
    [],
    [
      html.h2([], [external_link_text(url, package.name)]),
      html.p_text([], package.description),
    ],
  )
}

fn external_link_text(url: String, text: String) -> Node(t) {
  html.a_text(
    [attrs.href(url), attrs.rel("noopener noreferrer"), attrs.target("_blank")],
    text,
  )
}

fn layout(content: Node(t)) -> Node(t) {
  html.Fragment([
    html.head([
      html.meta([attrs.charset("utf-8")]),
      html.meta([
        attrs.name("viewport"),
        attrs.content("width=device-width, initial-scale=1"),
      ]),
      html.title_text([], "Gleam Packages"),
      html.link([attrs.rel("stylesheet"), attrs.href("/styles.css")]),
      html.link([
        attrs.rel("icon"),
        attrs.href("https://gleam.run/images/lucy-circle.svg"),
      ]),
      html.Element(
        "script",
        [
          attrs.defer(),
          attrs.src("https://plausible.io/js/plausible.js"),
          attrs.Attr("data-domain", "packages.gleam.run"),
        ],
        [],
      ),
    ]),
    content,
    html.footer(
      [attrs.class("site-footer")],
      [
        html.div(
          [],
          [
            html.Text("Special thanks to the "),
            external_link_text("https://hex.pm/", "Hex"),
            html.Text(" team."),
          ],
        ),
        html.div(
          [],
          [
            html.Text("Kindly hosted by "),
            external_link_text("https://fly.io/", "Fly"),
            html.Text("."),
          ],
        ),
        html.div(
          [],
          [
            external_link_text(
              "https://github.com/gleam-lang/packages",
              "Source code",
            ),
            html.Text("."),
          ],
        ),
      ],
    ),
  ])
}
