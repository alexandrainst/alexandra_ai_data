"""API for accessing processed data from Domsdatabasen."""

from logging import getLogger
from typing import Union

from datasets import load_dataset
from domsdatabasen import DatasetBuilder, Processor, Scraper
from omegaconf import DictConfig

from .config_domsdatabasen import config

logger = getLogger(__name__)


class Domsdatabasen:
    """API for accessing processed data from Domsdatabasen.

    Attributes:
        config (DictConfig):
            Configuration settings object.
        scraper (Scraper):
            Scraper object for scraping data from Domsdatabasen.
        processor (Processor):
            Processor object for processing scraped data.
        dataset_builder (DatasetBuilder):
            DatasetBuilder object for building dataset samples.
        dataset (Dataset):
            Dataset of processed data from Domsdatabasen.
    """

    def __init__(self):
        """Initialize."""
        self.config: DictConfig = config
        self.dataset = load_dataset("alexandrainst/domsdatabasen", split="train")

        # The following objects will not be initialized until
        # the first time they are needed.
        self.scraper = None
        self.processor = None
        self.dataset_builder = None

    def get_case(self, case_id: Union[str, int]) -> dict:
        """Get processed data for a case from Domsdatabasen.

        If the case_id is already in the dataset, the data is returned from the dataset.
        Else, the case will be scraped and processed.

        Args:
            case_id (str, int):
                The case_id of the case to get data for.

        Returns:
            dataset_sample (dict):
                Processed data for the case.
        """
        if isinstance(case_id, int):
            case_id = str(case_id)

        # Check if case_id is already in dataset
        for dataset_sample in self.dataset:
            if dataset_sample["case_id"] == case_id:
                logger.info(f"Found case_id {case_id} in cached dataset.")
                return dataset_sample

        # If case_id is not in dataset, scrape and process the case
        logger.info(
            f"Case_id {case_id} not found in cached dataset. "
            "Scraping and processing the case..."
        )
        self._initialze_objects()
        self.scraper.scrape(case_id=case_id)
        processed_data = self.processor.process(case_id=case_id)
        dataset_sample = self.dataset_builder.make_dataset_sample(
            processed_data=processed_data
        )

        return dataset_sample

    def _initialze_objects(self):
        """Initialize Scraper, Processor and DatasetBuilder objects.

        We don't want to initialize these objects before they are needed.
        """
        if self.scraper is not None:
            return

        self.scraper = Scraper(config=self.config)
        self.processor = Processor(config=self.config)
        self.dataset_builder = DatasetBuilder(config=self.config)
