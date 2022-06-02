view: brand_order_facts {

    derived_table: {
      explore_source: order_items {
        column: product_brand { field: products.brand }
        column: total_revenue_conditional {}
        derived_column: brand_rank {
          sql: row_number() over (order by total_revenue_conditional desc) ;;
        }
      }
    }
    dimension: brand_rank {
        hidden: yes
        type: number
    }
    dimension: product_brand {}
    dimension: total_revenue_conditional {
      value_format: "$#,##0.00"
      type: number
    }
  dimension: brand_rank_concat {
    label: "Brand Name"
    type: string
    sql: ${brand_rank} || ') ' || ${product_brand} ;;
  }
  dimension: brand_rank_top_5 {
    hidden: yes
    type: yesno
    sql: ${brand_rank} <= 5 ;;
  }
  dimension: brand_rank_grouped {
    label: "Brand Name Grouped"
    type: string
    sql: case when ${brand_rank_top_5} then ${brand_rank_concat} else '6) Other' end ;;
  }
}
