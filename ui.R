# load shiny package
library(shiny)
# begin shiny UI
shinyUI(navbarPage("Melt pool geometry predictions",
                   # create first tab
                   tabPanel("Process",
                            # load MathJax library so LaTeX can be used for math equations
                            withMathJax(), h3("Selective laser melting"),
                            # paragraph
                            p("Selective laser melting is an additive manufacturing process that uses 3D CAD data as a digital information
                              source and energy in the form of a high-power laser beam, to create three-dimensional metal parts by fusing
                              fine metal powders together."),
                            #br(),
                            p("In this process, acceptable quality requires process control in four fronts:"),
                            #br(),
                            # ordered list
                            tags$ol(
                              tags$li("Identification and reduction of under- and over-melting defects."),
                              tags$li("Dimensional accuracy and surface finish."),
                              tags$li("Microstructural and mechanical properties."),
                              tags$li("Reduction of residual stresses.")
                            ),
                            #br(),
                            p("Melt pool geometry (length, width, and depth) are often used as key performance indicators (KPIs) due to their direct
                              relationship with the thermal processes that determine these four qualities. Unfortunately melt pool geometry is hard to
                              predict due to the complex multi-physics nature of the manufacturing process. Significant effort is dedicated to the
                              development of high-fidelity computational models that predict melt pool geometry for a given combination of material and
                              processing conditions. This process is not very efficient because of the high computational cost, that results in long
                              simulations that may take up  to several weeks, even when implemented on super computers."),
                            #br(),
                            p("As an alternative, predictions from a computational model will be used as data points to construct a metamodel (a model
                              of a model), which is expected to return much faster predictions. In this case, the material chosen was", strong("Inconel 625"),
                              " and the data was obtained from the ABAQUS model of SLM developed at the National Institute of Standards and Technology (NIST).
                              The model predicts", strong("melt pool length and width"), " for a given combination of", strong("laser power"), " and ",
                              strong("scan speed"), "."),
                            br(),
                            p(strong("Disclaimer:"), "NIST-developed software is expressly provided AS IS. NIST MAKES NO WARRANTY OF ANY KIND,
                              EXPRESS, IMPLIED, IN FACT OR ARISING BY OPERATION OF LAW, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTY OF
                              MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT AND DATA ACCURACY. NIST NEITHER REPRESENTS
                              NOR WARRANTS THAT THE OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE, OR THAT ANY DEFECTS WILL BE CORRECTED.
                              NIST DOES NOT WARRANT OR MAKE ANY REPRESENTATIONS REGARDING THE USE OF THE SOFTWARE OR THE RESULTS THEREOF, INCLUDING BUT
                              NOT LIMITED TO THE CORRECTNESS, ACCURACY, RELIABILITY, OR USEFULNESS OF THE SOFTWARE.")
                            ),
                   # second tab
                   tabPanel("Metamodel",
                            # fluid row for space holders
                            fluidRow(
                              # fluid columns
                              column(4, div(style = "height: 200px")),
                              column(4, div(style = "height: 120px")),
                              column(4, div(style = "height: 200px"))),
                            # Main panel
                            mainPanel(
                              p('Melt pool width prediction (microns)'),
                              verbatimTextOutput('width'),
                              p('Melt pool length prediction (microns)'),
                              verbatimTextOutput('length')
                            ),
                            # absolute panel
                            absolutePanel(
                              # position attributes
                              top = 50, left = 0, right =0,
                              fixed = TRUE,
                              # panel with predefined background
                              wellPanel(
                                fluidRow(
                                  # sliders
                                  column(4, sliderInput("Power", "Laser power (W):",
                                                        min = 180, max = 210, value = 195)),
                                  column(4, sliderInput("Speed", "Scan speed (mm/s):",
                                                        min = 600, max = 1000, value = 800)),
                                style = "opacity: 0.92; z-index: 100;"
                                )),
                              submitButton("Submit")
                            )
                   )))
