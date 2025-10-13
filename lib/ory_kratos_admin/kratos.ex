defmodule OryKratosAdmin.Kratos do
  @moduledoc """
  The Kratos context.
  """

  import Ecto.Query, warn: false
  alias OryKratosAdmin.Repo

  alias OryKratosAdmin.Kratos.Identity

  def list_identities(%{"page_size" => page_size, "page_number" => page_number} = filters) do
    query =
      Enum.reduce(filters, Identity, fn
        {"sort_direction", dir}, query when dir in ~w(asc desc) ->
          order_by(query, [idx], {^:"#{dir}", idx.created_at})

        {"identifier.contains", identifiers}, query ->
          [iden, value] = String.split(identifiers, ",")

          where(query, [idx], ilike(fragment("jsonb_extract_path(?, ?)::text", idx.traits, ^iden), ^"%#{value}%"))

        {"metadata_public.has_key." <> _idx, paths}, query ->
          where(query, [idx], not is_nil(fragment("jsonb_extract_path(?, variadic ?::text[])", idx.metadata_public, ^String.split(paths, "."))))

        {"metadata_public.contains." <> _idx, paths_val}, query ->
          [paths, value] = String.split(paths_val, ",")

          where(query, [idx], ilike(fragment("jsonb_extract_path(?, variadic ?::text[])::text", idx.metadata_public, ^String.split(paths, ".")), ^"%#{value}%"))

        {"metadata_public.equals." <> _idx, paths_val}, query ->
          [paths, value] = String.split(paths_val, ",")

          where(query, [idx], fragment("jsonb_extract_path_text(?, variadic ?::text[])", idx.metadata_public, ^String.split(paths, ".")) == ^value)

        _filter, query ->
          query
      end)

    {
      query |> limit(^page_size) |> offset(^(page_number * page_size)) |> Repo.all(),
      query |> exclude(:order_by) |> select(count()) |> Repo.one()
    }
  end

  def create_identity(attrs) do
    %Identity{}
    |> Identity.changeset(attrs)
    |> Repo.insert()
  end
end
