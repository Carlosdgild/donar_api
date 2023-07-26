# frozen_string_literal: true

module Pagination
  DEFAULT_PAGE_NUMBER = 1
  DEFAULT_MIN_PER_PAGE = 5
  DEFAULT_MAX_PER_PAGE = 1000

  #
  # Module responsible for paginating resources
  #
  module Paginate
    #
    # Paginates resources
    #
    # @param [Any] resources The resources to paginate
    #
    # @return [Array] an array containg the resources and the metadata
    #
    def paginate_resources(resources)
      page_number = Integer(params[:page].presence || DEFAULT_PAGE_NUMBER)
      per_page = Integer(params[:per_page].presence || DEFAULT_MIN_PER_PAGE)

      page_number = DEFAULT_PAGE_NUMBER if page_number < 1
      per_page = DEFAULT_MIN_PER_PAGE if per_page < 1
      per_page = DEFAULT_MAX_PER_PAGE if per_page > DEFAULT_MAX_PER_PAGE

      page = resources&.page(page_number)&.per(per_page)
      [page, build_pagination_meta(page, [page_number, per_page])]
    end

    private

    def build_pagination_meta(page, opts)
      page_number, per_page = opts
      {
        total_pages: page&.total_pages,
        page_number: page_number,
        max_per_page: per_page,
        total_resources: page&.total_count
      }
    end
  end
end
